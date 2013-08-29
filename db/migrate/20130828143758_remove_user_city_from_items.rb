class RemoveUserCityFromItems < ActiveRecord::Migration
  def up
    change_table(:items) do |t|
      t.remove :user_id
      t.remove :city_id
    end
  end

  def down
    change_table(:items) do |t|
      t.column :user_id, :integer
      t.column :city_id, :integer
    end
  end
end
