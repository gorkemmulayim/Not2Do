class User < ActiveRecord::Migration
  def self.up
      create_table :users do |t|
         t.column :username, :string, :limit => 32, :null => false, :unique => true
         t.column :email, :string, :limit => 128, :null => false, :unique => true
         t.column :password, :string, :limit => 64, :null => false
         t.column :name, :string, :limit => 32, :null => false
         t.column :surname, :string, :limit => 32
         t.column :pp_url, :string, :limit => 128
         t.column :bio, :string, :limit => 256
         #t.column :created_at, :timestamp, :null => false, :default => Time.now
         t.timestamps :null => false
      end
   end

   def self.down
      drop_table :users
   end
end
