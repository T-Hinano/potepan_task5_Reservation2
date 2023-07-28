class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.integer :user_id
      t.string :roomname
      t.integer :price
      t.string :address
      t.text :detail
      t.string :image
      t.string :image_cache

      t.timestamps
    end
  end
end
