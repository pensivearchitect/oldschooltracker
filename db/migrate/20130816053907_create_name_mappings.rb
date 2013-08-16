class CreateNameMappings < ActiveRecord::Migration
  def change
    create_table :name_mappings do |t|
      t.integer :pid
      t.string :name

      t.timestamps
    end
  end
end
