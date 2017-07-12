class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, id: false do |t|
      t.string :name, null: false, limit: 64
      t.string :surname, null: false, limit: 64
      t.string :username, primary_key: true, limit: 20
      t.string :email, unique: true, null: false, limit: 64
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
