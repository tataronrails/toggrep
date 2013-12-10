class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.references :manager, index: true
      t.references :worker, index: true
      t.references :project, index: true
      t.integer :limit_min
      t.integer :limit_max
      t.date :started_at
      t.date :ended_at
      t.string :state

      t.timestamps
    end
  end
end
