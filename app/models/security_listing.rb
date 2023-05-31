# frozen_string_literal: true

class SecurityListing < ApplicationRecord
  belongs_to :security, polymorphic: true
  belongs_to :exchange
end
