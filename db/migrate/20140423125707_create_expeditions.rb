class CreateExpeditions < ActiveRecord::Migration
  def change
    create_table :expeditions do |t|
      t.references :user, index: true
      t.date :take_aboard
      t.date :delivered
      t.integer :region, default: 1
      t.string :comment
      t.timestamps
    end
    add_index :expeditions, :delivered
    add_index :expeditions, :take_aboard
    add_index :expeditions, :region
    add_column :loadups, :expedition_id, :integer
    add_index :loadups, :expedition_id
  end
end
