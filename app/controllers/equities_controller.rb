class EquitiesController < ApplicationController
  before_action :set_equity, only: %i[ show edit update destroy ]

  # GET /equities or /equities.json
  def index
    @equities = Equity.with_exchange_symbol
  end

  # GET /equities/1 or /equities/1.json
  def show
  end

  # GET /equities/new
  def new
    @equity = Equity.new
  end

  # GET /equities/1/edit
  def edit
  end

  # POST /equities or /equities.json
  def create
    @equity = Equity.new(equity_params)

    respond_to do |format|
      if @equity.save
        format.html { redirect_to equity_url(@equity), notice: "Equity was successfully created." }
        format.json { render :show, status: :created, location: @equity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @equity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equities/1 or /equities/1.json
  def update
    respond_to do |format|
      if @equity.update(equity_params)
        format.html { redirect_to equity_url(@equity), notice: "Equity was successfully updated." }
        format.json { render :show, status: :ok, location: @equity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @equity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equities/1 or /equities/1.json
  def destroy
    @equity.destroy

    respond_to do |format|
      format.html { redirect_to equities_url, notice: "Equity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

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
    exchange, equity, id =
        *params[:id].match(/\A(?<id>[[:digit:]]+)|(?:(?<exchange>[^:]+):)?(?<equity>[^:]+)\z/)
                    &.values_at(:exchange, :equity, :id)

    # We don't technically need this, but catching these cases here reduces DB
    # usage.
    raise ActionController::RoutingError,
          "invalid id: #{params[:id]}" unless id || equity

    if id
      @equity = Equity.find(id)
    elsif exchange && equity
      @equity = Equity.find_by_compound_symbol!(exchange:, equity:)
    elsif equity
      @equity = Equity.find_by_symbol!(equity)
    end
  rescue ActiveRecord::RecordNotFound
    raise unless set_exchange(exchange) || equity.upcase!

    if @exchange && equity
      redirect_to request.parameters
                         .merge(id: "#{@exchange.symbol}:#{equity}"),
                  status: 302
    else
      redirect_to request.parameters.merge(id: equity), status: 302
    end
  end

  ##
  # Initializes the @exchange instance variable and returns +true+ if the
  # record was found via case insensitive search.
  def set_exchange(exchange)
    @exchange = Exchange.find_by_symbol!(exchange) if exchange

    false
  rescue ActiveRecord::RecordNotFound
    @exchange = Exchange.find_by_symbol_case_insensitive!(exchange)
    true
  end

  # Only allow a list of trusted parameters through.
  def equity_params
    params.require(:equity).permit(:symbol, :name)
  end
end
