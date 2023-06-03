# frozen_string_literal: true

require 'test_helper'

class AssetPairsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @asset_pair = asset_pairs(:one)
  end

  test 'should get index' do
    get asset_pairs_url
    assert_response :success
  end

  test 'should get new' do
    get new_asset_pair_url
    assert_response :success
  end

  test 'should create asset_pair' do
    assert_difference('AssetPair.count') do
      post asset_pairs_url,
           params: { asset_pair: {
             base_asset_id: @asset_pair.base_asset_id,
             base_asset_type: @asset_pair.base_asset_type,
             base_rate: @asset_pair.base_rate,
             counter_asset_id: @asset_pair.counter_asset_id,
             counter_asset_type: @asset_pair.counter_asset_type,
             counter_rate: @asset_pair.counter_rate,
             observed_at: @asset_pair.observed_at
           } }
    end

    assert_redirected_to asset_pair_url(AssetPair.last)
  end

  test 'should show asset_pair' do
    get asset_pair_url(@asset_pair)
    assert_response :success
  end

  test 'should get edit' do
    get edit_asset_pair_url(@asset_pair)
    assert_response :success
  end

  test 'should update asset_pair' do
    patch asset_pair_url(@asset_pair),
          params: { asset_pair: {
            base_asset_id: @asset_pair.base_asset_id,
            base_asset_type: @asset_pair.base_asset_type,
            base_rate: @asset_pair.base_rate,
            counter_asset_id: @asset_pair.counter_asset_id,
            counter_asset_type: @asset_pair.counter_asset_type,
            counter_rate: @asset_pair.counter_rate,
            observed_at: @asset_pair.observed_at
          } }
    assert_redirected_to asset_pair_url(@asset_pair)
  end

  test 'should destroy asset_pair' do
    assert_difference('AssetPair.count', -1) do
      delete asset_pair_url(@asset_pair)
    end

    assert_redirected_to asset_pairs_url
  end
end
