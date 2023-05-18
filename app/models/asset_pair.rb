class AssetPair < ApplicationRecord
  belongs_to :base_asset, polymorphic: true
  belongs_to :counter_asset, polymorphic: true

  validates_associated :base_asset
  validates_associated :counter_asset

  validates :base_rate, numericality: { only_integer: true, other_than: 0 }
  validates :counter_rate, numericality: { only_integer: true }
  validates :observed_at, presence: true

  scope :in, ->(counter_asset) { where(counter_asset:) }
  scope :of, ->(base_asset) { where(base_asset:) }
  scope :mirror,
        -> {
          AssetPair.select('"subquery".base_asset_id      AS counter_asset_id',
                           '"subquery".counter_asset_id   AS base_asset_id',
                           '"subquery".base_asset_type   AS counter_asset_type',
                           '"subquery".counter_asset_type AS base_asset_type',
                           '"subquery".base_rate          AS counter_rate',
                           '"subquery".counter_rate       AS base_rate',
                           '"subquery".observed_at        AS observed_at')
                     .from(self, :subquery)
                     .order('"subquery".id ASC')
        }


  scope :after, ->(time, strict: false) {
                  where("observed_at #{strict ? '>' : '>='} ?", time)
                }
  scope :before, ->(time, strict: false) {
                   where("observed_at #{strict ? '<' : '<='} ?", time)
                 }
  scope :latest, ->(limit: 1) { order(observed_at: :desc).limit(limit) }
  scope :observed_near,
        ->(time, limit: 1) {
          order("ABS(TIMESTAMPDIFF(S, observed_at, ?)) ASC", time).limit(limit)
        }
  singleton_class.send(:alias_method, :at, :observed_near)

  scope :with_exchange_rate,
        -> {
          select(:base_rate, :counter_rate,
                 '(CAST(counter_rate AS FLOAT) / base_rate) AS exchange_rate')
        }

  def exchange_rate = Rational(counter_rate, base_rate)
  def exchange_rate=(rate)
    rate = Rational(rate)
    self.counter_rate = rate.numerator
    self.base_rate = rate.denominator
    rate
  end

  alias_attribute :exchange_value, :exchange_rate
  alias_attribute :fx_rate,        :exchange_rate
  alias_attribute :price,          :exchange_rate
  alias_attribute :rate,           :exchange_rate
  alias_attribute :value,          :exchange_rate

  def mirror
    attrs = attributes.reject { |key| key.in?(%w[id created_at updated_at]) }
                      .transform_keys do |key|
                        if key.start_with?('base_')
                          next key.sub('base_', 'counter_')
                        end

                        key.sub(/\Acounter_/, 'base_')
                      end

    self.class.new(attrs)
  end
end
