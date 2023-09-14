# frozen_string_literal: true

##
# Provides methods shared by controllers that have to do Option lookup.
module OptionsController::Finders
  extend ActiveSupport::Concern

  private

  def find_option(id)
    Option.find(id)
  end
end
