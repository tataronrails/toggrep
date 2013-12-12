class CreateViolationChecks < ActiveRecord::Migration
  def change
    create_table :violation_checks do |t|
      t.belongs_to :violation_rule,        :null => false
      t.belongs_to :agreement,        :null => false
      t.boolean :result,              :null => false, :default => false

      t.timestamps
    end
  end
end
