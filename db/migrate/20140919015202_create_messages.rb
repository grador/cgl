class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string  :name
      t.string  :body
      t.string  :status
      t.string  :comment
      t.timestamps
    end
  end
end
