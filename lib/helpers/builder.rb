# frozen_string_literal: true

module Helpers
  ##
  # Common interface for complex HTML generators.
  module Builder
    extend ActiveSupport::Concern

    attr_reader :parent, :view_context

    def initialize(view_context, parent = nil)
      @view_context = view_context
      @parent = parent
    end

    ##
    # Delegates to ActionView::Helpers::CaptureHelper#capture,
    # passing +self+ as first argument.
    def capture(*, &) = view_context.capture(self, *, &)

    ##
    # Delegate missing methods to #view_context.
    def method_missing(name, ...)
      return super unless view_context.respond_to?(name)

      view_context.__send__(name, ...)
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

    def respond_to_missing?(...) = view_context.respond_to?(...)
  end
end
