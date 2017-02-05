class CreateBeerclubs < ActiveRecord::Migration
  def change
    create_table :beerclubs do |t|
      t.string :name
      t.integer :founded
      t.string :city

      t.timestamps null: false
    end
  end
end
