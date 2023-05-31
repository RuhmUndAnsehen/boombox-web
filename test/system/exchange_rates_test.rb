# frozen_string_literal: true

require 'application_system_test_case'

class ExchangeRatesTest < ApplicationSystemTestCase
  setup do
    @exchange_rate = exchange_rates(:one)
  end

  test 'visiting the index' do
    visit exchange_rates_url
    assert_selector 'h1', text: 'Exchange rates'
  end

  test 'should create exchange rate' do
    visit exchange_rates_url
    click_on 'New exchange rate'

    fill_in 'Asset pair', with: @exchange_rate.asset_pair_id
    fill_in 'Base rate', with: @exchange_rate.base_rate
    fill_in 'Counter rate', with: @exchange_rate.counter_rate
    fill_in 'Observed at', with: @exchange_rate.observed_at
    click_on 'Create Exchange rate'

    assert_text 'Exchange rate was successfully created'
    click_on 'Back'
  end

  test 'should update Exchange rate' do
    visit exchange_rate_url(@exchange_rate)
    click_on 'Edit this exchange rate', match: :first

    fill_in 'Asset pair', with: @exchange_rate.asset_pair_id
    fill_in 'Base rate', with: @exchange_rate.base_rate
    fill_in 'Counter rate', with: @exchange_rate.counter_rate
    fill_in 'Observed at', with: @exchange_rate.observed_at
    click_on 'Update Exchange rate'

    assert_text 'Exchange rate was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Exchange rate' do
    visit exchange_rate_url(@exchange_rate)
    click_on 'Destroy this exchange rate', match: :first

    assert_text 'Exchange rate was successfully destroyed'
  end
end
