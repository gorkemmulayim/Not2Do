class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 64
      t.string :surname, null: false, limit: 64
      t.string :username, null: false, limit: 64
      t.string :email, null: false, limit: 64
      t.string :password, null: false, limit: 64

      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
