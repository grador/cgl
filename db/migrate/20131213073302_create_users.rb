class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.integer :owner_type
      t.integer :region, default: 1
      t.string :name
      t.string :address
      t.timestamps
    end
    add_index :users, :email
    add_index :users, :region
  end
end
