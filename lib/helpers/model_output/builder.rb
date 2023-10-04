# frozen_string_literal: true

require_relative '../builder'

module Helpers::ModelOutput
  ##
  # A HTML builder mixin.
  module Builder
    extend ActiveSupport::Concern
    include ::Helpers::Builder

    class_methods do
      ##
      # Defines attribute accessors and an automatic initializer for HTML tag
      # names relating to this object.
      #
      # @example
      #     class ExampleBuilder
      #       include Builder
      #
      #       tag_names :foo, bar: :baz
      #     end
      #
      #     builder = ExampleBuilder.new(foo_tag_name: :test)
      #     builder.foo_tag_name # => :test
      #     builder.bar_tag_name # => :baz
      def tag_names( # rubocop:disable Metrics/MethodLength
        *tags, **tags_with_defaults
      )
        tags_with_defaults.merge!(
          tags.to_h { |obj| obj.is_a?(Array) ? obj : [obj, nil] }
        ).transform_keys! { |tag| :"#{tag}_tag_name" }

        assignments = tags_with_defaults.map do |tag, default|
          "self.#{tag} = tag_names.fetch(#{tag.inspect}, #{default.inspect})"
        end

        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          attr_accessor #{tags_with_defaults.keys.map(&:inspect).join(', ')}

          def initialize_tag_names(tag_names)
            super

            #{assignments.join("\n")}
          end
        RUBY
      end
    end

    def initialize(*, **tag_names)
      super(*)

      initialize_tag_names(tag_names)
    end

    ##
    # Adds and returns HTML options specific to this object to the given
    # +options+.
    def component_options(options) = options

    ##
    # Like ActionView::Helpers::TagHelper#content_tag, but enhances +options+
    # by #component_options.
    def content_tag(name, content = nil, options = nil, ...)
      options = content if block_given? && content.is_a?(Hash)

      options = component_options(options)

      (parent || view_context).content_tag(name, content, options, ...)
    end

    private

    def initialize_tag_names(...); end
  end
end
