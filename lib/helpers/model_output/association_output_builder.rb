# frozen_string_literal: true

require_relative 'builder'

##
# A HTML builder for model associations.
class Helpers::ModelOutput::AssociationOutputBuilder
  include ::Helpers::ModelOutput::Builder

  attr_accessor :name, :raw_name

  delegate :loaded?, to: :@association

  tag_names :container, name: :dt, values: :dd, values_wrapper: :ul

  def initialize(*, association:, **, &block)
    super(*, **)

    initialize_association_attributes(association.to_s)

    @block = block
  end

  def component_options(options)
    options = add_class('many', to: options) if many?

    add_class('model-association', to: options)
  end

  def many? = value.is_a?(ActiveRecord::Associations::CollectionProxy)

  ##
  # Returns a HTML representation of this association.
  def to_s
    return capture(&@block) if @block

    if many?
      show_many(value)
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
    values = safe_join(values.map { |val| show_concise(val) })
    content = safe_join([name_tag(name),
                         values_tag(values_wrapper_tag(values))])

    content_tag_if_name(container_tag_name, content)
  end
end
