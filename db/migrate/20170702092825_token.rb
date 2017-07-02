class Token < ActiveRecord::Migration
    def self.up
      create_table :tokens, {:id => false} do |t|
         t.references :user, foreign_key: { to_table: :users }, index: true
         t.column :token, :string, :limit => 128
         t.column :expiration_date, :timestamp, :null => false, :default => (Time.now + 3.days)
      end
      execute "ALTER TABLE tokens ADD PRIMARY KEY (user_id);"
   end

   def self.down
      drop_table :tokens
   end
end
