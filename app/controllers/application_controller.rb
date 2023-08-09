# frozen_string_literal: true

require 'helpers/form_builder'

# :nodoc:
class ApplicationController < ActionController::Base
  default_form_builder ::Helpers::FormBuilder
end
