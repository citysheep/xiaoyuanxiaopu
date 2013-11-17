class AddZoneToItem < ActiveRecord::Migration
  def change
    add_column :items, :zone_id, :int
  end
end
