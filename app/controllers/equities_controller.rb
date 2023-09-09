# frozen_string_literal: true

# :nodoc:
class EquitiesController < ApplicationController
  include self::Finders

  before_action :set_equity, only: %i[show edit update destroy]

  # GET /equities or /equities.json
  def index
    @equities = equities
  end

  # GET /equities/1 or /equities/1.json
  def show
    @asset_pairs = AssetPair.of(@equity)
  end

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
    @equity = find_equity_or_redirect(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def equity_params
    params.require(:equity).permit(:symbol, :name)
  end
end
