class AddUiDtoUser < ActiveRecord::Migration
  def change
    add_column :users, :open_id, :integer
  end
end
