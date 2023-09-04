# frozen_string_literal: true

# :nodoc:
class EquitiesController < ApplicationController
  class << self
    # :nodoc:
    def find_equity(id)
      matches = parse_compound_symbol(id)

      case matches
      in id: String => id
        Equity.find(id)
      in exchange: String => exchange, equity: String => equity
        Equity.find_by_compound_symbol!(exchange:, equity:)
      in equity: String => symbol
        Equity.find_by!(symbol:)
      else
        raise ActionController::RoutingError, "invalid id: #{id}"
      end
    rescue ActiveRecord::RecordNotFound => e
      raise e unless block_given?

      # Use deconstruct_keys instead of named_captures because the latter
      # returns String keys, while the former returns Symbol keys.
      yield(**matches.deconstruct_keys(%i[equity exchange]), error: e)
    end

    # :nodoc:
    def parse_compound_symbol(symbol)
      symbol.match(
        /\A(?<id>[[:digit:]]+)|(?:(?<exchange>[^:]+):)?(?<equity>[^:]+)\z/
      )
    end
  end

  before_action :set_equity, only: %i[show edit update destroy]

  # GET /equities or /equities.json
  def index
    @equities = Equity.with_exchange_symbol
  end

  # GET /equities/1 or /equities/1.json
  def show; end

  # GET /equities/new
  def new
    @equity = Equity.new
  end

  # GET /equities/1/edit
  def edit; end

  # POST /equities or /equities.json
  def create
    @equity = Equity.new(equity_params)

    respond_to do |format|
      if @equity.save
        format.html do
          redirect_to equity_url(@equity),
                      notice: 'Equity was successfully created.'
        end
        format.json { render :show, status: :created, location: @equity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @equity.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /equities/1 or /equities/1.json
  def update
    respond_to do |format|
      if @equity.update(equity_params)
        format.html do
          redirect_to equity_url(@equity),
                      notice: 'Equity was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @equity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @equity.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /equities/1 or /equities/1.json
  def destroy
    @equity.destroy

    respond_to do |format|
      format.html do
        redirect_to equities_url, notice: 'Equity was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  delegate :find_equity, to: :class
  delegate :parse_compound_symbol, to: :class

  ##
  # Initializes the `@equity` instance variable.
  #
  # All of the following routes will show the same equity:
  # * equities/1
  # * equities/Nasdaq:AAPL
  # * equities/Nasdaq:aapl
  # * equities/AAPL
  # * equities/aapl
  def set_equity
    @equity = find_equity(params[:id])
  rescue ActiveRecord::RecordNotFound
    raise unless set_exchange(exchange) || equity.upcase!

    id = @exchange && equity ? "#{@exchange.symbol}:#{equity}" : equity
    redirect_to request.parameters.merge(id:), status: :found
  end

  ##
  # Initializes the @exchange instance variable and returns +true+ if the
  # record was found via case insensitive search.
  def set_exchange(exchange) # rubocop:disable Naming/AccessorMethodName
    @exchange = Exchange.find_by!(symbol: exchange) if exchange

    false
  rescue ActiveRecord::RecordNotFound
    # rubocop:disable Rails/DynamicFindBy
    @exchange = Exchange.find_by_symbol_case_insensitive!(exchange)
    # rubocop:enable  Rails/DynamicFindBy
    true
  end

  # Only allow a list of trusted parameters through.
  def equity_params
    params.require(:equity).permit(:symbol, :name)
  end
end
