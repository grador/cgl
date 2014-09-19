class CreateSlotereports < ActiveRecord::Migration
  def change
    create_table :slotereports do |t|
      t.references :report
      t.references :item
      t.integer    :quantity, default: 0
      t.integer    :q_box, default: 0
      t.string     :satatus
      t.string     :comment
      t.timestamps
    end
  end
end
