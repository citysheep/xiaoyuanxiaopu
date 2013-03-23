class MigrateAug23 < ActiveRecord::Migration
  def up
    change_table :items do |t|
      t.has_attached_file :photo
    end
  end

  def down
    drop_attached_file :items, :photo
  end
end
