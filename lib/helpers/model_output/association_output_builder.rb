# frozen_string_literal: true

require_relative 'builder'

##
# A HTML builder for model associations.
class Helpers::ModelOutput::AssociationOutputBuilder
  include ::Helpers::ModelOutput::Builder

  attr_accessor :name, :raw_name

  delegate :loaded?, to: :@association

  tag_names :container, name: :dt, values: :dd

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

    if value.is_a?(ActiveRecord::Associations::CollectionProxy)
      show_many(value, dom_id_tag_name: :li)
    else
      show(value,
           dom_id_tag_name: container_tag_name, embed: !container_tag_name)
    end
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

  def show_many(values, **)
    value = safe_join(values.map { |val| show(val, dom_id_tag_name: :li) })
    content = safe_join([content_tag(name_tag_name, name),
                         content_tag(values_tag_name, content_tag(:ul, value))])

    content_tag_if_name(container_tag_name, content)
  end
end
