class Enrichuser < ActiveRecord::Migration
  def change
	add_column :users, :open_avatar, :string
	add_column :users, :open_link, :string
  end
end
