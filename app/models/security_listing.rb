# frozen_string_literal: true

##
# Intermediary model for a polymorphic Security to Exchange many to many
# association.
class SecurityListing < ApplicationRecord
  belongs_to :security, polymorphic: true
  belongs_to :exchange
end
