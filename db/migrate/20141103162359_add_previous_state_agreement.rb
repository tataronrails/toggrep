class AddPreviousStateAgreement < ActiveRecord::Migration
  def change
    add_column :agreements, :previous_state, :string
  end
end
