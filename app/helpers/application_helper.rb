# frozen_string_literal: true

require 'enhanced/form_builder'

# :nodoc:
module ApplicationHelper
  ##
  # Decorates the built-in #form_with by switching the default form builder with
  # Enhanced::FormBuilder.
  def form_with(*, **opts, &)
    super(*, **{ builder: Enhanced::FormBuilder }.merge(opts), &)
  end
end
