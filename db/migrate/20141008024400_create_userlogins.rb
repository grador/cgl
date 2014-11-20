class CreateUserlogins < ActiveRecord::Migration
  def change
    create_table :userlogins do |t|
      t.integer     :user_id,       index: true, default: 0
      t.string      :ip_addr,       index: true
      t.timestamps
    end
  end
end
