class AddTogglApiToUsers < ActiveRecord::Migration
  def change
    add_column :users, :toggl_api, :string
  end
end
