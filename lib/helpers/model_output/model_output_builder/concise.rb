# frozen_string_literal: true

##
# A concise HTML builder for ActiveRecord models.
#
# This builder typically renders the value of the first attribute.
class Helpers::ModelOutput::ModelOutputBuilder::Concise <
  Helpers::ModelOutput::ModelOutputBuilder
  tag_names :association_list, :attribute_list, dom_id: :li

  def attributes(...) = super.first(1)
  def attribute_builder_class_name = "#{super}::Concise"
end
