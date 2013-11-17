class AddZoneToShop < ActiveRecord::Migration
  def change
    add_column :shops, :zone_id, :int

    create_table :zones do |t|
      t.string :name
      t.string :city_id

      t.timestamps
    end

  end
end
