class CreateCoordinates < ActiveRecord::Migration[7.2]
  def change
    create_table :coordinates do |t|
      t.text :address, null: false, index: {unique: true}
      t.string :lat, null: false
      t.text :lon, null: false
      t.timestamps
    end
  end
end
