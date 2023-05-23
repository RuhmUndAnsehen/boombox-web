require 'sti_preload/exchange_rate'

class ExchangeRate < ApplicationRecord
  include StiPreload::ExchangeRate

  before_save { write_attribute(:exchange_rate, exchange_rate.to_f) }

  belongs_to :asset_pair

  validates :base_rate, numericality: { only_integer: true, other_than: 0 }
  validates :counter_rate, numericality: { only_integer: true }
  validates :observed_at, presence: true

  # :section: Type selectors ################################################

  ##
  # Returns the records that have certain type.
  scope :of_type, ->(type) { where(type: type.to_s) }

  descendants.each do |type|
    scope :"of_type_#{type.to_s.tableize}", -> { of_type(type) }
  end

  # :section: Time selectors ################################################

  ##
  # Returns the records that were observed after the specified `time`.
  scope :after, ->(time, strict: false) {
                  where("observed_at #{strict ? '>' : '>='} ?", time)
                }

  ##
  # Returns the records that were observed before the specified `time`.
  scope :before, ->(time, strict: false) {
                   where("observed_at #{strict ? '<' : '<='} ?", time)
  }

  ##
  # Returns the records that were observed during the given time period.
  scope :during,
        ->(range, time = nil) {
          range = range...time if time.present?

          where(observed_at: range)
        }
  singleton_class.send(:alias_method, :between, :during)

  ##
  # Returns the record that was observed at the latest point in time, per
  # AssetPair.
  scope :latest,
        -> {
          group(:asset_pair)
            .having('MAX(observed_at)')
            .order(observed_at: :desc)
        }

  ##
  # Returns the records that were observed the closest to each of the specified # `times`, per AssetPair.
  scope :observed_near,
        -> (*times) {
          unless times.map(&:class)
                      .all?(&[Date, Time, DateTime].method(:include?))
            raise TypeError, 'all objects must be of temporal type'
          end

          timetable = times.map do |time|
            sanitize_sql_array(['SELECT ? AS sampled_at', time])
          end
          timetable = Arel.sql(timetable.join(' UNION '))

          abs_date_diff = 'ABS(UNIXEPOCH(observed_at) - UNIXEPOCH(sampled_at))'
          min_abs_date_diff   = "MIN(#{abs_date_diff})"
          order_abs_date_diff = Arel.sql("#{abs_date_diff} ASC")

          joins("CROSS JOIN (#{timetable})").select('*')
            .group(:asset_pair).group(:sampled_at)
            .having(min_abs_date_diff)
        }
  singleton_class.send(:alias_method, :at, :observed_near)

  # :section: Rate selectors ################################################

  scope :high, -> { group(:asset_pair).having('MAX(exchange_rate)') }
  scope :low, -> { group(:asset_pair).having('MIN(exchange_rate)') }

  # :section: Attributes

  attribute :observed_at, default: -> { Time.now }

  ##
  # Returns a singular (Rational) value for the exchange rate.
  def exchange_rate = Rational(counter_rate, base_rate)

  ##
  # Writer for #exchange_rate.
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

  # :section: Instance methods

  ##
  # Returns a new instance of this class with the exchange rate as if the
  # assets were reversed.
  def mirror
    attrs = attributes.reject { |key| key.in?(%w[id created_at updated_at]) }
    attrs[:base_rate], attrs[:counter_rate] =
        *attrs.values_at(:counter_rate, :base_rate)

    self.class.new(**attrs)
  end

  private

  # :nodoc:
  # Overrides the default behavior to delete the #exchange_rate attribute if
  # #base_rate or #counter_rate are present. This is for data integrity reasons.
  # The user is not supposed to modify #exchange_rate directly, it merely exists
  # to optimize DB queries. The actual value is in the rational number given by
  # `Rational(counter_rate / base_rate)`. This precision would be lost if we
  # were to infer them from a floating point number.
  def sanitize_for_mass_assignment(attributes)
    attributes.delete(:exchange_rate) if attributes.key?(:base_rate) ||
                                         attributes.key?(:counter_rate)

    super(attributes)
  end
end
