class CreateSendmen < ActiveRecord::Migration
  def change
    create_table :sendmen do |t|
      t.references  :message
      t.references  :user
      t.integer     :receiver, index: true
      t.string      :status
      t.string      :comment
      t.timestamps
    end
  end
end
