class RenameColumnTogglApiToTogglApiKey < ActiveRecord::Migration
  def change
    rename_column :users, :toggl_api, :toggl_api_key
  end
end
