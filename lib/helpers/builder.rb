# frozen_string_literal: true

module Helpers
  ##
  # Common interface for complex HTML generators.
  module Builder
    extend ActiveSupport::Concern

    attr_reader :parent, :view_context

    delegate_missing_to '(parent || view_context)'

    def initialize(view_context, parent = nil)
      @view_context = view_context
      @parent = parent
    end

    ##
    # Delegates to ActionView::Helpers::CaptureHelper#capture,
    # passing +self+ as first argument.
    def capture(*, &) = view_context.capture(self, *, &)

    ##
    # Like ActionView::Helpers::TagHelper#content_tag, but only wraps the
    # +content+ if +name+ is present. Otherwise returns content or evaluates the
    # block, if given.
    def content_tag_if_name(name, content = nil, options = {}, &block)
      return content_tag(name, content, options, &block) if name.present?
      return capture(&block) if block_given?

      content
    end

    ##
    # Works like #capture, except that it evaluates the block in
    # instance context.
    def self_capture(*, &)
      value = nil
      buffer = with_output_buffer { value = instance_exec(*, &) }
      string = buffer.presence || value
      ERB::Util.html_escape(string) if string.is_a?(String)
    end

    ##
    # Creates a new instance of this class where +parent+ points to the object
    # this method was called on.
    def new(...) = spawn_as(self.class, ...)
    alias spawn new

    ##
    # Creates a new instance of +klass+ where +parent+ points to the object this
    # method was called on.
    def spawn_as(klass, ...) = klass.new(view_context, self, ...)

    private

    def add_attribute(attr_hash = nil, to:, **attrs)
      to ||= {}
      (attr_hash || attrs)&.each do |key, value|
        to_value = to[key]
        to[key] = [to_value, value].compact.join(' ')
      end
      to
    end

    def add_class(cls, to:)
      cls = cls[:class] if cls.is_a?(Hash)

      add_attribute(class: cls, to:)
    end
  end
end
