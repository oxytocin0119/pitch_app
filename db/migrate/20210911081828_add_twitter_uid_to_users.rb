class AddTwitterUidToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :twitter_uid, :string
  end
end
