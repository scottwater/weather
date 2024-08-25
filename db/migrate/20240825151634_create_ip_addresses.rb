class CreateIpAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :ip_addresses do |t|
      t.string :ip, null: false, index: {unique: true}
      t.text :address, null: false
      t.timestamps
    end
  end
end
