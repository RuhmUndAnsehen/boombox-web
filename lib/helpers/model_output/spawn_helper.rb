# frozen_string_literal: true

require_relative 'builder'

##
# Provides methods to spawn builders.
module Helpers::ModelOutput::SpawnHelper
  extend ActiveSupport::Concern
  include ::Helpers::ModelOutput::Builder

  class << self
    def builder_spawner(name, class_name: nil, param: nil)
      param ||= name
      class_name ||= "Helpers::ModelOutput::#{name.to_s.classify}OutputBuilder"

      module_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{name}_builder(#{param}, **, &)
          spawn_as(#{name}_builder_class_name.constantize, #{param}:, **, &)
        end

        def #{name}_builder_class_name = #{class_name.inspect}
      RUBY
    end

    def builder_spawners(*names) = names.each(&method(:builder_spawner))
  end

  builder_spawners :association, :attribute, :model

  def show(...) = model_builder(...).to_s

  def spawn_as(*, **opts, &)
    opts = spawn_options(opts) if respond_to?(:spawn_options)

    super(*, **opts, &)
  end
end
