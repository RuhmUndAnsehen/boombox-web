# frozen_string_literal: true

require 'test_helper'

class ExchangeRatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exchange_rate = exchange_rates(:one)
  end

  test 'should get index' do
    get exchange_rates_url
    assert_response :success
  end

  test 'should get new' do
    get new_exchange_rate_url
    assert_response :success
  end

  test 'should create exchange_rate' do
    assert_difference('ExchangeRate.count') do
      post exchange_rates_url,
           params: { exchange_rate: {
             asset_pair_id: @exchange_rate.asset_pair_id,
             base_rate: @exchange_rate.base_rate,
             counter_rate: @exchange_rate.counter_rate,
             observed_at: @exchange_rate.observed_at
           } }
    end

    assert_redirected_to exchange_rate_url(ExchangeRate.last)
  end

  test 'should show exchange_rate' do
    get exchange_rate_url(@exchange_rate)
    assert_response :success
  end

  test 'should get edit' do
    get edit_exchange_rate_url(@exchange_rate)
    assert_response :success
  end

  test 'should update exchange_rate' do
    patch exchange_rate_url(@exchange_rate),
          params: { exchange_rate: {
            asset_pair_id: @exchange_rate.asset_pair_id,
            base_rate: @exchange_rate.base_rate,
            counter_rate: @exchange_rate.counter_rate,
            observed_at: @exchange_rate.observed_at
          } }
    assert_redirected_to exchange_rate_url(@exchange_rate)
  end

  test 'should destroy exchange_rate' do
    assert_difference('ExchangeRate.count', -1) do
      delete exchange_rate_url(@exchange_rate)
    end

    assert_redirected_to exchange_rates_url
  end
end
