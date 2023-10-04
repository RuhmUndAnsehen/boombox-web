# frozen_string_literal: true

require_relative 'builder'

##
# A HTML builder for model attributes.
class Helpers::ModelOutput::AttributeOutputBuilder
  include ::Helpers::ModelOutput::Builder

  attr_accessor :name, :raw_name, :type, :value

  tag_names :container, name: :dt, value: :dd

  def initialize(*, attribute:, **, &block)
    super(*, **)

    initialize_attribute_attributes(attribute.to_s)

    @block = block
  end

  def component_options(options)
    options = add_class(type, to: options) if type.present?

    add_class('model-attribute', to: options)
  end

  ##
  # Returns a HTML representation of this attribute.
  def to_s
    content = self_capture(&@block) if @block

    content ||= safe_join([content_tag(name_tag_name, name),
                           content_tag(value_tag_name, value)])
    return content if container_tag_name.blank?

    content_tag(container_tag_name, content)
  end

  private

  def initialize_attribute_attributes(raw_name)
    klass = parent.model.class

    self.name = klass.human_attribute_name(raw_name)
    self.raw_name = raw_name
    self.type = klass.columns_hash[raw_name]&.sql_type_metadata&.type
    self.value = parent.model.attributes[raw_name]
  end
end
