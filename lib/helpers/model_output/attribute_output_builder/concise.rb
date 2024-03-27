# frozen_string_literal: true

##
# A concise HTML builder for ActiveRecord models.
#
# This builder typically renders the value of the first attribute.
class Helpers::ModelOutput::AttributeOutputBuilder::Concise <
  Helpers::ModelOutput::AttributeOutputBuilder
  tag_names :name, :value

  def to_s
    content_tag_if_name(container_tag_name, link_to_if(link?, value, model))
  end
end
