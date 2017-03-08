class AddUsernameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :username, :string, limit: 100
    add_index :users, :username, unique: true
  end
end
