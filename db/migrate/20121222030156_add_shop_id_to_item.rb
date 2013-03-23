class AddShopIdToItem < ActiveRecord::Migration
  def change
  	add_column :items, :shop_id, :integer
  end
end
