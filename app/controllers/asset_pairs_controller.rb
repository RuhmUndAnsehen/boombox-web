# frozen_string_literal: true

class AssetPairsController < ApplicationController
  before_action :set_asset_pair, only: %i[show edit update destroy]

  # GET /asset_pairs or /asset_pairs.json
  def index
    @asset_pairs = AssetPair.all
  end

  # GET /asset_pairs/1 or /asset_pairs/1.json
  def show; end

  # GET /asset_pairs/new
  def new
    @asset_pair = AssetPair.new
  end

  # GET /asset_pairs/1/edit
  def edit; end

  # POST /asset_pairs or /asset_pairs.json
  def create
    @asset_pair = AssetPair.new(asset_pair_params)

    respond_to do |format|
      if @asset_pair.save
        format.html do
          redirect_to asset_pair_url(@asset_pair),
                      notice: 'Asset pair was successfully created.'
        end
        format.json { render :show, status: :created, location: @asset_pair }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @asset_pair.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /asset_pairs/1 or /asset_pairs/1.json
  def update
    respond_to do |format|
      if @asset_pair.update(asset_pair_params)
        format.html do
          redirect_to asset_pair_url(@asset_pair),
                      notice: 'Asset pair was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @asset_pair }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @asset_pair.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /asset_pairs/1 or /asset_pairs/1.json
  def destroy
    @asset_pair.destroy

    respond_to do |format|
      format.html do
        redirect_to asset_pairs_url,
                    notice: 'Asset pair was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_asset_pair
    @asset_pair = AssetPair.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def asset_pair_params
    params.require(:asset_pair).permit(:base_asset_id, :base_asset_type, :counter_asset_id, :counter_asset_type,
                                       :base_rate, :counter_rate, :observed_at)
  end
end
