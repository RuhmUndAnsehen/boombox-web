require "application_system_test_case"

class AssetPairsTest < ApplicationSystemTestCase
  setup do
    @asset_pair = asset_pairs(:one)
  end

  test "visiting the index" do
    visit asset_pairs_url
    assert_selector "h1", text: "Asset pairs"
  end

  test "should create asset pair" do
    visit asset_pairs_url
    click_on "New asset pair"

    fill_in "Base asset", with: @asset_pair.base_asset_id
    fill_in "Base asset type", with: @asset_pair.base_asset_type
    fill_in "Base rate", with: @asset_pair.base_rate
    fill_in "Counter asset", with: @asset_pair.counter_asset_id
    fill_in "Counter asset type", with: @asset_pair.counter_asset_type
    fill_in "Counter rate", with: @asset_pair.counter_rate
    fill_in "Observed at", with: @asset_pair.observed_at
    click_on "Create Asset pair"

    assert_text "Asset pair was successfully created"
    click_on "Back"
  end

  test "should update Asset pair" do
    visit asset_pair_url(@asset_pair)
    click_on "Edit this asset pair", match: :first

    fill_in "Base asset", with: @asset_pair.base_asset_id
    fill_in "Base asset type", with: @asset_pair.base_asset_type
    fill_in "Base rate", with: @asset_pair.base_rate
    fill_in "Counter asset", with: @asset_pair.counter_asset_id
    fill_in "Counter asset type", with: @asset_pair.counter_asset_type
    fill_in "Counter rate", with: @asset_pair.counter_rate
    fill_in "Observed at", with: @asset_pair.observed_at
    click_on "Update Asset pair"

    assert_text "Asset pair was successfully updated"
    click_on "Back"
  end

  test "should destroy Asset pair" do
    visit asset_pair_url(@asset_pair)
    click_on "Destroy this asset pair", match: :first

    assert_text "Asset pair was successfully destroyed"
  end
end
