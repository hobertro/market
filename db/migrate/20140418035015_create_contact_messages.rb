class CreateContactMessages < ActiveRecord::Migration
  def change
    create_table :contact_messages do |t|
      t.text :from
      t.string :to
      t.string :name
      t.string :content

      t.timestamps
    end
  end
end
