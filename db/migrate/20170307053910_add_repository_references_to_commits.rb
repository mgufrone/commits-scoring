class AddRepositoryReferencesToCommits < ActiveRecord::Migration[5.0]
  def change
    add_reference :commits, :repository, foreign_key: true
  end
end
