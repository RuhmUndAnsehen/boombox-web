# frozen_string_literal: true

require_relative 'builder'

##
# A HTML builder for model associations.
class Helpers::ModelOutput::AssociationOutputBuilder
  include ::Helpers::ModelOutput::Builder

  attr_accessor :name, :raw_name

  delegate :loaded?, to: :@association

  def initialize(*, association:, **, &block)
    super(*, **)

    initialize_association_attributes(association.to_s)

    @block = block
  end

  def component_options(options)
    add_class('model-association', to: options)
  end

  ##
  # Returns a HTML representation of this association.
  def to_s
    return capture(&@block) if @block

    content_tag(:div, value.to_human_s)
  end

  def type = nil
  def value = @association.owner.__send__(raw_name)

  private

  def initialize_association_attributes(raw_name)
    model = parent.model

    self.name = model.class.human_attribute_name(raw_name)
    self.raw_name = raw_name
    @association = model.association(raw_name)
  end
end
