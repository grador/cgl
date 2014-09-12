class RemovecolumninUser < ActiveRecord::Migration
  def change
  remove_column :users, :owner_type, :integer
  end
end
