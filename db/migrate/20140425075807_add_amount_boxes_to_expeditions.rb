class AddAmountBoxesToExpeditions < ActiveRecord::Migration
  def change
    add_column :expeditions, :amount_boxes, :integer
  end
end
