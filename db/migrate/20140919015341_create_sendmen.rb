class CreateSendmen < ActiveRecord::Migration
  def change
    create_table :sendmen do |t|
      t.references  :message
      t.references  :user
      t.integer     :sender, index: true
      t.string      :status, index: true
      t.string      :comment
      t.timestamps
    end
  end
end
