class RenameIdToPid < ActiveRecord::Migration
  def change
    rename_column :name_mappings, :id, :pid
  end
end
