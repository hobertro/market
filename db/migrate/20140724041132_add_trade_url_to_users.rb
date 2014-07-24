class AddTradeUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :trade_url, :text
  end
end
