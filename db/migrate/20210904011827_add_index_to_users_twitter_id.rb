class AddIndexToUsersTwitterId < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :twitter_id, unique: true
  end
end
