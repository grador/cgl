class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.date :deliver_at
      t.integer :expeditor
      t.date :delivered
      t.integer :region, default: 1
      t.string :comment
      t.integer :q_box
      t.timestamps
    end
    add_index :orders, :deliver_at
    add_index :orders, :expeditor
    add_index :orders, :region
    add_index :orders, :delivered
  end
end
