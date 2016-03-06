class CreateUserProviders < ActiveRecord::Migration
  def change
    create_table :user_providers do |t|
      t.references :user, index: true, foreign_key: true
      t.string :uid
      t.string :provider, limit: 20

      t.timestamps null: false
    end
    add_index :user_providers, :provider
  end
end
