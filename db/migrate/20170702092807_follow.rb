class Follow < ActiveRecord::Migration
    def self.up
      create_table :follows, {:id => false} do |t|
        t.integer :follower_id, index: true
        t.integer :following_id, index: true
        t.timestamps null: false
      end
      add_foreign_key :follows, :users, column: :follower_id
      add_foreign_key :follows, :users, column: :following_id
      execute "ALTER TABLE follows ADD PRIMARY KEY (follower_id, following_id);"
   end

   def self.down
      drop_table :follows
   end
end
