# frozen_string_literal: true

##
# A financial option.
class Option < ApplicationRecord
  include Asset

  # The table has a +type+ column, so we're disabling STI by setting the
  # inheritance_column to some bogus value.
  self.inheritance_column = 'foo'

  class << self
    def find_nearest_expiry(ref = Time.zone.now)
      not_expired(ref).order(expires_at: :asc).limit(1).pluck(:expires_at)
    end

    ##
    # Joins ExchangeRate through AssetPair. If a block is given, also yields
    # ExchangeRate to the block and returns the merged relation.
    def joins_exchange_rates
      query = joins(underlying: :exchange_rates)
      return query unless block_given?

      query.merge(yield(ExchangeRate))
    end
  end

  belongs_to :underlying, class_name: 'AssetPair'

  enum :style, { american: 1, european: 0 }
  enum :type, { call: 1, put: 0 }

  validates :expires_at, presence: true
  validates :style, presence: true
  validates :strike, numericality: { greater_than: 0 }
  validates :strike_denominator,
            numericality: { only_integer: true, greater_than: 0 }
  validates :strike_numerator,
            numericality: { only_integer: true, greater_than: 0 }
  validates :type, presence: true

  # :section: Time selectors #################################################

  ##
  # Returns a relation where all records have the smallest #expires_at that's
  # larger than +ref+.
  #
  # :call-seq: expiring_next(ref = Time.zone.now) => ...
  scope :expiring_next,
        ->(*args) { where(expires_at: find_nearest_expiry(*args)) }

  ##
  # Returns a relation of records where #expires_at is less or equal than +ref+.
  scope :expired, ->(ref = Time.zone.now) { where('expires_at <= ?', ref) }

  ##
  # Returns a relation where #expires_at is larger than +ref+.
  scope :not_expired, ->(ref = Time.zone.now) { where('expires_at > ?', ref) }

  ##
  # Returns a relation that selects a pseudo column populated with the
  # differences between #expires_at and +ref+
  scope :select_seconds_to_expiry,
        lambda { |ref = Time.zone.now|
          select(sanitize_sql(['UNIXEPOCH(expires_at) - ? AS seconds_to_expiry',
                               ref.to_i]))
        }

  # :section: Moneyness selectors ############################################

  ##
  # Returns a relation for in-the-money (ITM) options.
  #
  # A call option is ITM if the spot price is larger or equal than the #strike
  # price, and a put option is ITM if the spot price is less or equal than the
  # #strike price.
  #
  # @see #out_of_the_money
  # @see #where_strike
  scope :in_the_money,
        lambda { |spot = nil|
          call.where_strike('<=', spot).or(put.where_strike('>=', spot))
        }
  singleton_class.alias_method :itm, :in_the_money

  ##
  # Returns a relation for out-of-the-money (OTM) options.
  #
  # An option is OTM if it is not #itm.
  #
  # @see #in_the_money
  # @see #where_strike
  scope :out_of_the_money,
        lambda { |spot = nil|
          call.where_strike('>', spot).or(put.where_strike('<', spot))
        }
  singleton_class.alias_method :otm, :out_of_the_money

  ##
  # Returns a relation where +op+ would return +true+ if invoked on #strike and
  # +spot+.
  #
  # +op+ must be one of: +[< <= = <> != >= >]+
  # If +spot+ is not given, then availability of an #exchange_rate column is
  # assumed. This can be ensured with #joins_exchange_rates like so:
  #     Option.joins_exchange_rates.where_strike('>')
  #     # => SELECT "options".* FROM "options"
  #            INNER JOIN "asset_pairs"
  #            ON "asset_pairs"."id" = "options"."underlying_id"
  #            INNER JOIN "exchange_rates"
  #            ON "exchange_rates"."asset_pair_id" = "asset_pairs"."id"
  #            WHERE (strike > exchange_rate)
  # A more realistic example, which selects all ITM puts options provided the
  # last recorded ExchangeRate, looks like this:
  #     Option.joins_exchange_rates(&:latest).put.where_strike('>=')
  #     # => SELECT "options".* FROM "options"
  #            INNER JOIN "asset_pairs"
  #            ON "asset_pairs"."id" = "options"."underlying_id"
  #            INNER JOIN "exchange_rates"
  #            ON "exchange_rates"."asset_pair_id" = "asset_pairs"."id"
  #            WHERE "options"."type" = 0 AND (strike >= exchange_rate)
  #            GROUP BY "asset_pair_id"
  #            HAVING (MAX(observed_at))
  # However, there are convenience scopes available that utilize this one to
  # select ITM/OTM options (both methods include both calls and puts).
  #
  # @see #in_the_money
  # @see #out_of_the_money
  scope :where_strike,
        lambda { |op, spot = nil|
          op = op.to_s
          legal_ops = %w[< <= = <> != >= >].freeze

          # Assert that op is one of several predetermined legal values.
          unless op.in?(legal_ops)
            raise ArgumentError,
                  "op must be one of #{legal_ops.inspect}, got: #{op}"
          end

          # Determine the right-hand-side depending on if spot is nil. If it
          # isn't, we're generating a prepared statement, safely interpolating
          # the value, otherwise we're going to default to the exchange_rate
          # column during query.
          rhs = spot.nil? ? 'exchange_rate' : '?'
          where(*["strike #{op} #{rhs}", spot].compact)
        }

  # :section: Other Scopes ###################################################

  ##
  # Preloads #base_asset and #counter_asset.
  scope :includes_underlying_assets,
        -> { preload(underlying: %i[base_asset counter_asset]) }

  # :section: Instance methods ###############################################

  ##
  # Returns +true+ if the option is ITM.
  def in_the_money?(spot) = call? && spot >= strike || put? && spot <= strike
  alias itm? in_the_money?

  ##
  # Returns +true+ if the option is OTM.
  def out_of_the_money?(spot) = call? && spot < strike || put? && spot > strike
  alias otm? out_of_the_money?

  ##
  # Returns the contents of the attribute +seconds_to_expiry+.
  #
  # @see #select_seconds_to_expiry
  def seconds_to_expiry = attributes['seconds_to_expiry']

  ##
  # Returns the time to expiry (relative to +now+) as an
  # ActiveSupport::Duration.
  def time_to_expiry(now = Time.zone.now)
    (expires_at.to_datetime - now.to_datetime).days
  end
end
