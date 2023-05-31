# frozen_string_literal: true

class CountriesController < ApplicationController
  before_action :set_country, only: %i[show edit update destroy]

  # GET /countries or /countries.json
  def index
    @countries = Country.all
  end

  # GET /countries/1 or /countries/1.json
  def show; end

  # GET /countries/new
  def new
    @country = Country.new
  end

  # GET /countries/1/edit
  def edit; end

  # POST /countries or /countries.json
  def create
    @country = Country.new(country_params)

    respond_to do |format|
      if @country.save
        format.html do
          redirect_to country_url(@country),
                      notice: 'Country was successfully created.'
        end
        format.json { render :show, status: :created, location: @country }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @country.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /countries/1 or /countries/1.json
  def update
    respond_to do |format|
      if @country.update(country_params)
        format.html do
          redirect_to country_url(@country),
                      notice: 'Country was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @country }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @country.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /countries/1 or /countries/1.json
  def destroy
    @country.destroy

    respond_to do |format|
      format.html do
        redirect_to countries_url, notice: 'Country was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_country
    @country = Country.smart_find!(params.delete(:id))
  end

  # Only allow a list of trusted parameters through.
  def country_params
    params.require(:country).permit(:name, :alpha2_code, :alpha3_code,
                                    :numeric_code)
  end
end
