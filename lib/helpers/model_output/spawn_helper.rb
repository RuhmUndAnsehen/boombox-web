# frozen_string_literal: true

require_relative 'builder'

##
# Provides methods to spawn builders.
module Helpers::ModelOutput::SpawnHelper
  extend ActiveSupport::Concern
  include ::Helpers::ModelOutput::Builder

  def association_builder(association, &block)
    spawn_as(::Helpers::ModelOutput::AssociationOutputBuilder,
             association:, &block)
  end

  def attribute_builder(attribute, &block)
    spawn_as(::Helpers::ModelOutput::AttributeOutputBuilder, attribute:, &block)
  end
end
