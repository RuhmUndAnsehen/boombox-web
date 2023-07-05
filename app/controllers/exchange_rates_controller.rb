# frozen_string_literal: true

# :nodoc:
class ExchangeRatesController < ApplicationController
  before_action :set_asset_pair, only: %i[index show new destroy]
  before_action :set_exchange_rate, only: %i[show edit update destroy]

  # GET /exchange_rates or /exchange_rates.json
  def index
    @exchange_rates = ExchangeRate.where(asset_pair: @asset_pair)
  end

  # GET /exchange_rates/1 or /exchange_rates/1.json
  def show; end

  # GET /exchange_rates/new
  def new
    @exchange_rate = ExchangeRate.new(asset_pair: @asset_pair)
  end

  # GET /exchange_rates/1/edit
  def edit; end

  # POST /exchange_rates or /exchange_rates.json
  def create
    @exchange_rate = ExchangeRate.new(exchange_rate_params)

    respond_to do |format|
      if @exchange_rate.save
        format.html do
          redirect_to asset_pair_url(@exchange_rate.asset_pair,
                                     exchange_rate_id: @exchange_rate,
                                     exchange_rate_type: @exchange_rate.type),
                      notice: 'Exchange rate was successfully created.'
        end
        format.json { render :show, status: :created, location: @exchange_rate }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @exchange_rate.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /exchange_rates/1 or /exchange_rates/1.json
  def update
    respond_to do |format|
      if @exchange_rate.update(exchange_rate_params)
        format.html do
          redirect_to asset_pair_url(@exchange_rate.asset_pair,
                                     highlight: @exchange_rate),
                      notice: 'Exchange rate was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @exchange_rate }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @exchange_rate.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /exchange_rates/1 or /exchange_rates/1.json
  def destroy
    @exchange_rate.destroy

    respond_to do |format|
      format.html do
        redirect_to asset_pair_url(@asset_pair),
                    notice: 'Exchange rate was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exchange_rate
    @exchange_rate = ExchangeRate.find(params[:id])
  end

  def set_asset_pair
    @asset_pair = AssetPair.find(params[:asset_pair_id])
  end

  # Only allow a list of trusted parameters through.
  def exchange_rate_params
    params.require(:exchange_rate).permit(:asset_pair_id, :base_rate,
                                          :counter_rate, :observed_at)
  end
end
