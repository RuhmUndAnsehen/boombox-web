# frozen_string_literal: true

require_relative 'builder'

##
# A HTML builder for model attributes.
class Helpers::ModelOutput::AttributeOutputBuilder
  include ::Helpers::ModelOutput::Builder

  attr_accessor :index, :link, :name, :raw_name, :type, :type_limit, :value

  tag_names :container, name: :dt, value: :dd

  def initialize(*, attribute:, index: nil, link: 0, **, &block)
    super(*, **)

    self.index = index
    self.link = link

    initialize_attribute_attributes(attribute.to_s)

    @block = block
  end

  def component_options(options)
    options = add_class(type_limit_class, to: options)
    add_class(type, to: options) if type.present?

    add_class('model-attribute', to: options)
  end

  ##
  # Returns +true+ if this builder should generate a link to the
  # model it belongs to.
  def link?
    link.in?([true, index, raw_name]) ||
      link.is_a?(Symbol) && link.to_s == raw_name
  end

  ##
  # Returns a HTML representation of this attribute.
  def to_s
    return content_tag_if_name(container_tag_name, &@block) if @block

    content = safe_join([name_tag(name),
                         value_tag(link_to_if(link?, value, model))])

    content_tag_if_name(container_tag_name, content)
  end

  ##
  # Returns a CSS class for #type_limit.
  def type_limit_class
    type_limit.present? ? "limit-#{type_limit}" : 'unlimited'
  end

  private

  def initialize_attribute_attributes(raw_name)
    klass = model.class
    type_metadata = klass.columns_hash[raw_name]&.sql_type_metadata

    self.name = klass.human_attribute_name(raw_name)
    self.raw_name = raw_name
    self.type = type_metadata&.type
    self.type_limit = type_metadata&.limit
    self.value = model.attributes[raw_name]
  end
end
