class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.float :price
      t.string :image, default: 'https://i.ytimg.com/vi/Xw1C5T-fH2Y/maxresdefault.jpg'
      t.boolean :active?, default: true
      t.integer :inventory
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
