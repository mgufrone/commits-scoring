class CreateScores < ActiveRecord::Migration[5.0]
  def change
    create_table :scores do |t|
      t.references :commit, foreign_key: true
      t.references :user, foreign_key: true
      t.decimal :score, precision: 3, scale: 2

      t.timestamps
    end
  end
end
