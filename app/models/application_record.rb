# frozen_string_literal: true

# :nodoc:
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  class << self
    alias t human_attribute_name

    ##
    # Returns the I18n translation for the given enum value.
    def human_enum_name(enum, value) = human_attribute_name("#{enum}.#{value}")

    ##
    # Returns a hash of enum value and #human_enum_name combinations.
    def human_enum_values(enum)
      __send__(enum.to_s.pluralize)
        .each_key.index_with { |val| human_enum_name(enum, val) }
    end
  end

  delegate :t, to: :class

  ##
  # Returns a human-readable String representation of this object.
  def to_s_human(*keys, **opts)
    *scope, key = :activerecord, :to_s_human, model_name.i18n_key, *keys
    I18n.t(key, scope:, **{ default: to_s }.merge(attributes, opts))
  end
end
