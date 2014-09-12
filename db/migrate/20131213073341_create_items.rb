class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string  :name
      t.string  :full
      t.string  :art
      t.integer :box
      t.integer :num, default: nil
      t.timestamps
    end
    add_index :items, :name
    add_index :items, :art
  end
end

