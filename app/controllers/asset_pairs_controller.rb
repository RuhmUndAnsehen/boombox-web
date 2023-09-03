# frozen_string_literal: true

# :nodoc:
class AssetPairsController < ApplicationController
  class << self
    ##
    # Returns a relation selecting all AssetPairs. In subclasses, returns a
    # relation selecting all AssetPairs where +base_asset_type+ is
    # +subclass::model_name+.
    def asset_pairs
      return AssetPair.all if self == AssetPairsController

      "AssetPair::#{model_name}".constantize.all
    end

    def find_asset_pair(id) = asset_pairs.find(id)
  end

  delegate :asset_pairs, to: :class

  before_action :set_asset_pair, only: %i[show edit update destroy]

  # GET /asset_pairs or /asset_pairs.json
  def index
    @asset_pairs = asset_pairs.preload_all(&:latest_or_none)
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

  delegate :find_asset_pair, to: :class

  # Use callbacks to share common setup or constraints between actions.
  def set_asset_pair
    @asset_pair = find_asset_pair(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def asset_pair_params
    params.require(:asset_pair).permit(:base_asset_id, :base_asset_type,
                                       :counter_asset_id, :counter_asset_type)
  end
end
