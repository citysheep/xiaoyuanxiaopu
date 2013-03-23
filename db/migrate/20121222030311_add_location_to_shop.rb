class AddLocationToShop < ActiveRecord::Migration
  def change
    add_column :shops, :lat, :float
    add_column :shops, :lng, :float
  end
end
