# frozen_string_literal: true

##
# Form builder mixin that defines a method for working with rational numbers.
module RationalColumn::FormBuilder
  extend ActiveSupport::Concern

  ##
  # Returns a #number_field, but converts the value #to_f so browsers don't
  # remove Rational#to_s values.
  #
  # The exact behavior might change, later.
  def rational_field(attr, **opts)
    value = opts.key?(:value) ? opts[:value] : object.__send__(attr)
    opts[:value] = value.to_f
    number_field(attr, **opts)
  end
end
