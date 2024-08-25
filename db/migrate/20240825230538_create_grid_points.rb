class CreateGridPoints < ActiveRecord::Migration[7.2]
  def change
    create_table :grid_points do |t|
      t.string :lat, null: false
      t.text :lon, null: false
      t.string :grid_id, null: false
      t.string :grid_x, null: false
      t.string :grid_y, null: false

      t.timestamps
    end

    add_index :grid_points, [:lat, :lon], unique: true
  end
end
