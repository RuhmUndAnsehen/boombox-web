class TimezoneValidator < ActiveModel::EachValidator
  ##
  # Validates if +value+ identifies a Timezone.
  def validate_each(record, attribute, value)
    TZInfo::Timezone.get(value)
  rescue StandardError => error
    message = options[:message] || error.message
    record.errors.add(attribute, message)
  end
end
