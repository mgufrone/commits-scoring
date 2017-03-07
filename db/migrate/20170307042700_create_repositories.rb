class CreateRepositories < ActiveRecord::Migration[5.0]
  def change
    create_table :repositories do |t|
      t.string :url
      t.string :name
      t.string :label

      t.timestamps
    end
    add_index :repositories, :url, unique: true
    add_index :repositories, :name, unique: true
  end
end
