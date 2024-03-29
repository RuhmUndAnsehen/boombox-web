# frozen_string_literal: true

# :nodoc:
class ExchangesController < ApplicationController
  before_action :set_exchange, only: %i[show edit update destroy]
  before_action :set_country, only: %i[index show new create]

  # GET /exchanges or /exchanges.json
  def index
    @exchanges = Exchange.all
  end

  # GET /exchanges/1 or /exchanges/1.json
  def show; end

  # GET /exchanges/new
  def new
    @exchange = Exchange.new(country: @country)
  end

  # GET /exchanges/1/edit
  def edit; end

  # POST /exchanges or /exchanges.json
  def create
    @exchange = Exchange.new(exchange_params)

    respond_to do |format|
      if @exchange.save
        format.html do
          redirect_to exchange_url(@exchange),
                      notice: 'Exchange was successfully created.'
        end
        format.json { render :show, status: :created, location: @exchange }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @exchange.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /exchanges/1 or /exchanges/1.json
  def update
    respond_to do |format|
      if @exchange.update(exchange_params)
        format.html do
          redirect_to exchange_url(@exchange),
                      notice: 'Exchange was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @exchange }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @exchange.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /exchanges/1 or /exchanges/1.json
  def destroy
    @exchange.destroy

    respond_to do |format|
      format.html do
        redirect_to exchanges_url,
                    notice: 'Exchange was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exchange
    @exchange = Exchange.smart_find!(params[:id])
  rescue ActiveRecord::RecordNotFound
    # rubocop:disable Rails/DynamicFindBy
    exchange = Exchange.find_by_symbol_case_insensitive!(params[:id])
    # rubocop:enable  Rails/DynamicFindBy
    redirect_to request.parameters.merge(id: exchange.symbol)
  end

  def set_country
    @country = @exchange&.country || Country.smart_find(params[:country_id])
  end

  # Only allow a list of trusted parameters through.
  def exchange_params
    params.require(:exchange).permit(:country_id, :symbol, :name, :timezone)
  end
end
