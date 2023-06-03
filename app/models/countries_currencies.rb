# frozen_string_literal: true

##
# Joins model for a Country to Currency many to many association.
class CountriesCurrencies < ApplicationRecord
  belongs_to :country
  belongs_to :currency
end
