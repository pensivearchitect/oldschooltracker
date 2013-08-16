class RemovePid < ActiveRecord::Migration
  def change
    remove_column :name_mappings, :pid
  end
end
