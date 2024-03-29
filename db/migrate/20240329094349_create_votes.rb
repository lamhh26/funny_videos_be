class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true
      t.integer :vote_type
      t.check_constraint 'vote_type IN (-1, 1)'

      t.timestamps
    end
  end
end
