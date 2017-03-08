class CreateCommits < ActiveRecord::Migration[5.0]
  def change
    create_table :commits do |t|
      t.string :sha, limit: 150
      t.datetime :commited_at
      t.references :user, foreign_key: true
      t.text :message

      t.timestamps
    end
    add_index :commits, :sha, unique: true
  end
end
