class Participate < ActiveRecord::Migration
    def self.up
      create_table :participate, {:id => false} do |t|
        t.references :user, foreign_key: { to_table: :users }, index: true
        t.references :not2do, foreign_key: { to_table: :not2do }, index: true
        t.integer :supervisor_id, index: true
        t.boolean :failed, :default => false
        t.timestamps null: false
      end
      add_foreign_key :participate, :users, column: :supervisor_id
      execute "ALTER TABLE participate ADD PRIMARY KEY (user_id, not2do_id);"
   end

   def self.down
      drop_table :participate
   end
end
