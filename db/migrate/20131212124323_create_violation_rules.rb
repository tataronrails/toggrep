class CreateViolationRules < ActiveRecord::Migration
  def change
    create_table :violation_rules do |t|
      t.string :condition,        :null => false, :default => ''
      t.string :assert_each,        :null => false, :default => ''
      t.text :description,        :null => false

      t.timestamps
    end
  end
end
