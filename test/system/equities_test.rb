# frozen_string_literal: true

require 'application_system_test_case'

class EquitiesTest < ApplicationSystemTestCase
  setup do
    @equity = equities(:one)
  end

  test 'visiting the index' do
    visit equities_url
    assert_selector 'h1', text: 'Equities'
  end

  test 'should create equity' do
    visit equities_url
    click_on 'New equity'

    fill_in 'Name', with: @equity.name
    fill_in 'Symbol', with: @equity.symbol
    click_on 'Create Equity'

    assert_text 'Equity was successfully created'
    click_on 'Back'
  end

  test 'should update Equity' do
    visit equity_url(@equity)
    click_on 'Edit this equity', match: :first

    fill_in 'Name', with: @equity.name
    fill_in 'Symbol', with: @equity.symbol
    click_on 'Update Equity'

    assert_text 'Equity was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Equity' do
    visit equity_url(@equity)
    click_on 'Destroy this equity', match: :first

    assert_text 'Equity was successfully destroyed'
  end
end
