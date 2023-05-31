class AddTimezoneColumnToExchanges < ActiveRecord::Migration[7.0]
  def change
    change_table :exchanges do |t|
      t.string :timezone
    end
  end
end
