class AddIndexToUsersTwitterUid < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :twitter_uid, unique: true
  end
end
