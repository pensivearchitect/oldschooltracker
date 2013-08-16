class CreateDataPoints < ActiveRecord::Migration
  def change
    create_table :data_points do |t|
      t.integer :pid
      t.integer :time
      t.string :xp
      t.string :rank

      t.timestamps
    end
  end
end
