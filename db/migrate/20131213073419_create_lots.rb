class CreateLots < ActiveRecord::Migration
  def change
    create_table :lots do |t|
      t.references :item, index: true
      t.references :order, index: true
      t.integer :quantity 
      t.timestamps
    end
  end
end


