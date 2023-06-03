# frozen_string_literal: true

##
# Validator for TZInfo::Timezone identifiers.
class TimezoneValidator < ActiveModel::EachValidator
  ##
  # Validates if +value+ identifies a Timezone.
  def validate_each(record, attribute, value)
    TZInfo::Timezone.get(value)
  rescue StandardError => e
    message = options[:message] || e.message
    record.errors.add(attribute, message)
  end
end
