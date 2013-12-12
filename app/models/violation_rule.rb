class ViolationRule < ActiveRecord::Base

  has_many :violation_checks

  validates :assert_each, presence: true
  validates_format_of :assert_each,
    with: /\d+\.(year|month|week|day|hour|minute|second)s?/i,
    on: :create,
    message: "%{value} must be like '1.day', '8.hour'"
  validates :condition, presence: true
  validates :description, presence: true

end
