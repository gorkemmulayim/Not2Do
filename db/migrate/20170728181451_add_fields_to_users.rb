class AddFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string
    add_column :users, :surname, :string
    add_column :users, :username, :string
    add_column :users, :bio, :text, default: "Add a descriptive bio here..."
    add_column :users, :fcm_token, :text
  end
end