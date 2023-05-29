require "test_helper"

class EquitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equity = equities(:one)
  end

  test "should get index" do
    get equities_url
    assert_response :success
  end

  test "should get new" do
    get new_equity_url
    assert_response :success
  end

  test "should create equity" do
    assert_difference("Equity.count") do
      post equities_url, params: { equity: { name: @equity.name, symbol: @equity.symbol } }
    end

    assert_redirected_to equity_url(Equity.last)
  end

  test "should show equity" do
    get equity_url(@equity)
    assert_response :success
  end

  test "should get edit" do
    get edit_equity_url(@equity)
    assert_response :success
  end

  test "should update equity" do
    patch equity_url(@equity), params: { equity: { name: @equity.name, symbol: @equity.symbol } }
    assert_redirected_to equity_url(@equity)
  end

  test "should destroy equity" do
    assert_difference("Equity.count", -1) do
      delete equity_url(@equity)
    end

    assert_redirected_to equities_url
  end
end
