class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :country
      t.string :city_jp
      t.string :city_en
      t.decimal :lat
      t.decimal :lng
      t.string :city_type
      t.string :layer
      t.string :code_no

      t.timestamps
    end
  end
end
