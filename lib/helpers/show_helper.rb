# frozen_string_literal: true

require_relative 'model_output/model_output_builder'

##
# Provides a method to generate HTML representations of ActiveRecord models.
module Helpers::ShowHelper
  ##
  # Returns a HTML representation for +model+.
  #
  # :call-seq:
  #   show(model, attributes: nil, associations: [], **tag_names, &block)
  def show(model, **, &)
    ::Helpers::ModelOutput::ModelOutputBuilder.new(self, model:, **, &)
  end
end
