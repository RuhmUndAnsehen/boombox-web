# frozen_string_literal: true

# :nodoc:
class EquitiesController < ApplicationController
  class << self
    # :nodoc:
    def parse_compound_symbol(symbol)
      symbol
      .match(/\A(?<id>[[:digit:]]+)|(?:(?<exchange>[^:]+):)?(?<equity>[^:]+)\z/)
      &.values_at(:exchange, :equity, :id)
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
    exchange, equity, id = *parse_compound_symbol(params[:id])

    @equity = _set_equity_helper(exchange:, equity:, id:)
  rescue ActiveRecord::RecordNotFound
    raise unless set_exchange(exchange) || equity.upcase!

    id_hash = if @exchange && equity
                { id: "#{@exchange.symbol}:#{equity}" }
              else
                { id: equity }
              end
    redirect_to request.parameters.merge(id_hash), status: :found
  end

  # :nodoc:
  def _set_equity_helper(exchange:, equity:, id:)
    # We don't technically need this, but catching these cases here reduces DB
    # usage.
    unless id || equity
      raise ActionController::RoutingError, "invalid id: #{params[:id]}"
    end

    if id
      Equity.find(id)
    elsif exchange && equity
      Equity.find_by_compound_symbol!(exchange:, equity:)
    elsif equity
      Equity.find_by!(symbol: equity)
    end
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
