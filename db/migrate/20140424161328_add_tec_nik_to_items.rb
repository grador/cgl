class AddTecNikToItems < ActiveRecord::Migration
  def change
    add_column :items, :technic, :integer
  end
end
