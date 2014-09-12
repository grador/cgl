class AddstringToUser < ActiveRecord::Migration
  def change
  add_column :users, :type_owner, :string
  reversible do |dir|
      dir.up { User.update_all type_owner: 'admin' }
    end
  end
end
