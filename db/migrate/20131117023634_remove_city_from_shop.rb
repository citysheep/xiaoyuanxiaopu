class RemoveCityFromShop < ActiveRecord::Migration
  def up
    change_table(:shops) do |t|
      t.remove :city_id
    end
  end

  def down
    change_table(:shops) do |t|
      t.column :city_id, :integer
    end
  end
end
