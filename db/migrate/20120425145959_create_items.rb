class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :price
      t.string :description
      t.integer :user_id
      t.integer :buyer
      t.integer :category_id
      
      t.timestamps
    end
  end
end
