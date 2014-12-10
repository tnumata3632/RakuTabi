class CreateAsks < ActiveRecord::Migration
  def change
    create_table :asks do |t|
      t.string :question
      t.string :image_l
      t.string :image_r

      t.timestamps
    end
  end
end
