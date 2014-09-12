class CreateLoadups < ActiveRecord::Migration
  def change
    create_table :loadups do |t|
      t.references :item, index: true
      t.references :user, index: true
      t.integer :quantity, default: 0 
      t.integer :q_box, default: 0
      t.date    :take_aboard
      t.integer :region, default: 1
      t.string  :comment
      t.timestamps
    end
    add_index :loadups, :take_aboard
    add_index :loadups, :region
  end
end
