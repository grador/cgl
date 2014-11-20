class AddDefaultsToUser < ActiveRecord::Migration
  def change
    add_column :users, :defaults, :string
  end
end
