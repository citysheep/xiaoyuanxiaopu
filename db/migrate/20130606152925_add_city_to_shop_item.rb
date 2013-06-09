class AddCityToShopItem < ActiveRecord::Migration
  def change
    add_column :items, :city_id, :int
    add_column :shops, :city_id, :int
  end
end
