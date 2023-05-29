class Currency < ApplicationRecord
  include Alpha3Indexable
  include Asset

  has_and_belongs_to_many :countries

  validates :currency, presence: true
  with_options uniqueness: { scope: :active }, if: :active do
    validates :alphabetic_code, format: { with: /\A[A-Z]{3}\z/ },
                                length: { is: 3 }
    validates :numeric_code, length: { in: 1..3 },
                             numericality: { only_integer: true }
  end

  default_scope { active.order(alpha3_code: :asc) }

  scope :active, -> { where(active: true) }
  scope :historical, -> { rewhere(active: [nil, false]) }

  attribute :active, default: true

  alias_attribute :country, :countries

  alias_attribute :abc,         :alphabetic_code
  alias_attribute :abc_code,    :alphabetic_code
  alias_attribute :alpha,       :alphabetic_code
  alias_attribute :alpha3,      :alphabetic_code
  alias_attribute :alpha3_code, :alphabetic_code
  alias_attribute :alphabetic,  :alphabetic_code

  alias_attribute :xyz,      :numeric_code
  alias_attribute :xyz_code, :numeric_code
  alias_attribute :num,      :numeric_code
  alias_attribute :num_code, :numeric_code
  alias_attribute :number,   :numeric_code
  alias_attribute :numeric,  :numeric_code

  def to_param = active ? super : id
end
