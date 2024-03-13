class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :url, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
