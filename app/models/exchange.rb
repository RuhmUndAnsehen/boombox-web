class Exchange < ApplicationRecord
  belongs_to :country

  has_many :security_listings, dependent: :destroy
  has_many :equities, through: :security_listings, source: :security,
           source_type: 'Equity'

  validates :symbol, format: { without: /:/ }, uniqueness: true, presence: true

  scope :equities,
        -> { Equity.with_exchange_symbol.where(exchanges: self) }
end
