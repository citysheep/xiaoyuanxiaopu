class AddLocationSupport < ActiveRecord::Migration
  def change
    add_column :items, :lat, :float
    add_column :items, :lng, :float
  end
end
