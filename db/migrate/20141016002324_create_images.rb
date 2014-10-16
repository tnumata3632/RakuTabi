class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image_id
      t.string :keywords
      t.string :path

      t.timestamps
    end
  end
end
