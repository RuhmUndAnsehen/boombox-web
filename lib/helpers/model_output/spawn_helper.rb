# frozen_string_literal: true

require_relative 'builder'

##
# Provides methods to spawn builders.
module Helpers::ModelOutput::SpawnHelper
  extend ActiveSupport::Concern
  include ::Helpers::ModelOutput::Builder

  def association_builder(association, **, &)
    spawn_as(::Helpers::ModelOutput::AssociationOutputBuilder,
             association:, **, &)
  end

  def attribute_builder(attribute, **, &)
    spawn_as(::Helpers::ModelOutput::AttributeOutputBuilder, attribute:, **, &)
  end

  def model_builder(model, **opts, &)
    spawn_as(::Helpers::ModelOutput::ModelOutputBuilder, model:, **opts, &)
  end

  def show(...) = model_builder(...).to_s

  def spawn_as(*, **opts, &)
    opts = spawn_options(opts) if respond_to?(:spawn_options)

    super(*, **opts, &)
  end
end
