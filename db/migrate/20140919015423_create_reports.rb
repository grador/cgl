class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references  :user
      t.integer     :inspect_id, index: true
      t.date        :data_begin
      t.date        :data_end
      t.integer     :q_box, default: 0
      t.integer     :quantity, default: 0
      t.string      :status
      t.string      :comment
      t.timestamps
    end
  end
end
