class ViolationCheck < ActiveRecord::Base

  belongs_to :violation_rule
  belongs_to :agreement

  validates :result, presence: true

end
