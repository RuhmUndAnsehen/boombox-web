class Country < ApplicationRecord
  include Alpha3Indexable

  has_and_belongs_to_many :currencies
  has_many :exchanges

  with_options presence: true,
               uniqueness: true do |unique|
    validates :name, format: { without: /[[:lower:]]/ }

    with_options format: { with: /\A[[:upper:]]{2,3}\z/ } do
      validates :alpha2_code, length: { is: 2 }
      validates :alpha3_code, length: { is: 3 }
    end

    validates :numeric_code, length: { in: 1..3 }, numericality: true
  end

  class << self
    def smart_lookup(id) = super.or(where(alpha2_code: id))
  end

  default_scope { order(alpha3_code: :asc) }

  alias_attribute :currency, :currencies

  alias_attribute :ab,      :alpha2_code
  alias_attribute :ab_code, :alpha2_code
  alias_attribute :alpha2,  :alpha2_code

  alias_attribute :abc,      :alpha3_code
  alias_attribute :abc_code, :alpha3_code
  alias_attribute :alpha3,   :alpha3_code

  alias_attribute :xyz,      :numeric_code
  alias_attribute :xyz_code, :numeric_code
  alias_attribute :num,      :numeric_code
  alias_attribute :num_code, :numeric_code
  alias_attribute :number,   :numeric_code
  alias_attribute :numeric,  :numeric_code
end
