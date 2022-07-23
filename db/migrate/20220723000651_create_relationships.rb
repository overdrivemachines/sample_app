class CreateRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # A user can’t follow another user more than once
    # Multiple-key index that enforces uniqueness
    add_index :relationships, [:followed_id, :followed_id], unique: true
  end
end
