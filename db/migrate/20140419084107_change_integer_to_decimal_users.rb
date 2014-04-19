class ChangeIntegerToDecimalUsers < ActiveRecord::Migration
  def up
    change_column :users, :primary_clanid, :decimal
  end

  def down
    change_column :users, :primary_clanid, :integer
  end
end
