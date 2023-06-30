# frozen_string_literal: true

require 'sti_preload/exchange_rate'

##
# For most assets, this simply represents the value of the asset (#base_asset)
# in a currency (#counter_asset).
# The value is processed as Rational and stored as #counter_rate (numerator) and
# #base_rate (denominator) in the database.
class ExchangeRate < ApplicationRecord
  include StiPreload::ExchangeRate

  class << self
    def denominator_column_name(name)
      return 'base_rate' if name == 'exchange_rate'

      super
    end

    def numerator_column_name(name)
      return 'counter_rate' if name == 'exchange_rate'

      super
    end
  end

  belongs_to :asset_pair

  validates :base_rate, numericality: { only_integer: true, other_than: 0 }
  validates :counter_rate, numericality: { only_integer: true }
  validates :observed_at, presence: true

  # :section: Type selectors ################################################

  ##
  # Returns the records that have certain type.
  scope :of_type, ->(type) { where(type: type.to_s) }

  # :section: Time selectors ################################################

  ##
  # Returns the records that were observed after the specified `time`.
  scope :after, lambda { |time, strict: false|
                  where("observed_at #{strict ? '>' : '>='} ?", time)
                }

  ##
  # Returns the records that were observed before the specified `time`.
  scope :before, lambda { |time, strict: false|
    where("observed_at #{strict ? '<' : '<='} ?", time)
  }

  ##
  # Returns the records that were observed during the given time period.
  scope :during,
        lambda { |range, time = nil|
          range = range...time if time.present?

          where(observed_at: range)
        }
  singleton_class.send(:alias_method, :between, :during)

  ##
  # Returns the record that was observed at the latest point in time, per
  # AssetPair.
  scope :latest, -> { group(:asset_pair_id).having('MAX(observed_at)') }

  ##
  # Returns the records that were observed the closest to each of the specified
  # +times+, per AssetPair.
  scope :observed_near,
        lambda { |*times|
          timetable = times.map(&:to_i).map! do |time|
            sanitize_sql(['SELECT ? AS sampled_at', time])
          end
          timetable = Arel.sql(timetable.join(' UNION '))

          abs_date_diff = 'ABS(UNIXEPOCH(observed_at) - sampled_at)'
          min_abs_date_diff = "MIN(#{abs_date_diff})"

          joins("CROSS JOIN (#{timetable})").select('*')
                                            .group(:asset_pair_id)
                                            .group(:sampled_at)
                                            .having(min_abs_date_diff)
        }
  singleton_class.send(:alias_method, :at, :observed_near)

  # :section: Rate selectors ################################################

  scope :high, -> { group(:asset_pair_id).having('MAX(exchange_rate)') }
  scope :low, -> { group(:asset_pair_id).having('MIN(exchange_rate)') }

  # :section: Attributes

  attribute :observed_at, default: -> { Time.zone.now }

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
end
