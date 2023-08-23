# frozen_string_literal: true

require 'helpers/form_builder'

# :nodoc:
class ApplicationController < ActionController::Base
  default_form_builder ::Helpers::FormBuilder

  class << self
    ##
    # Returns the stringyfied class name of the ActiveRecord model that should
    # be associated with this controller.
    #
    # By default, this is the demodulized controller name (without the
    # "Controller"), singularized.
    #
    # Does not check if the model class is actually defined.
    def model_name = name.demodulize[..-11].singularize
  end
end
