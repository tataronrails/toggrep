class CreateTogglUsers < ActiveRecord::Migration
  def change
    create_table :toggl_users do |t|
      t.belongs_to :user,       :null => false
      t.integer :uid,            :null => false, :default => 0
      t.string :email,          :null => false, :default => ""
      t.string :fullname,       :null => false, :default => ""

      t.timestamps
    end
  end
end
