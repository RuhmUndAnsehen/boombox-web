# frozen_string_literal: true

# :nodoc:
class OptionsController < ApplicationController
  include ::OptionsController::Finders

  before_action :set_option, only: %i[show edit compute update destroy]
  before_action :set_underlying, only: %i[index show new destroy]

  # GET /options or /options.json
  def index
    @options = Option.includes_underlying_assets

    @options = @options.where(underlying: @underlying) if @underlying
  end

  # GET /options/1 or /options/1.json
  def show
    @asset_pairs = AssetPair.of(@option)
  end

  # GET /options/new
  def new
    @option = Option.new(underlying: @underlying)
  end

  # GET /options/1/edit
  def edit; end

  # POST /asset_pairs/1/options/1/job
  def compute
    respond_to do |format|
      format.html { render :show }
      format.json { render :show }
    end
  end

  # POST /options or /options.json
  def create
    @option = Option.new(option_params)

    respond_to do |format|
      if @option.save
        format.html do
          redirect_to option_url(@option),
                      notice: 'Option was successfully created.'
        end
        format.json { render :show, status: :created, location: @option }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @option.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /options/1 or /options/1.json
  def update
    respond_to do |format|
      if @option.update(option_params)
        format.html do
          redirect_to option_url(@option),
                      notice: 'Option was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @option }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @option.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /options/1 or /options/1.json
  def destroy
    @option.destroy

    respond_to do |format|
      format.html do
        redirect_to asset_pair_options_url(@underlying),
                    notice: 'Option was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_option
    @option = find_option(params[:id])
  end

  def set_underlying
    @underlying = @option&.underlying ||
                  AssetPair.find_by(id: params[:asset_pair_id] ||
                                        params[:underlying_id])
  end

  # Only allow a list of trusted parameters through.
  def option_params
    params.require(:option)
          .permit(:underlying_id, :expires_at, :type, :style, :strike)
  end
end
