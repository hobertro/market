class AddAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :community_visibility, :integer
    add_column :users, :profile_state, :integer
    add_column :users, :last_logoff, :integer
    add_column :users, :profile_url, :string
    add_column :users, :avatar, :string
    add_column :users, :avatar_medium, :string
    add_column :users, :avatar_full, :string
    add_column :users, :primary_clanid, :integer
    add_column :users, :time_created, :integer
    add_column :users, :persona_stateflags, :integer
    add_column :users, :person_state, :integer
  end
end
