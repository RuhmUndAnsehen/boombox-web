class Exchange < ApplicationRecord
  belongs_to :country

  validates :symbol, uniqueness: true
end
