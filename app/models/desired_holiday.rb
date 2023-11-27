class DesiredHoliday < ApplicationRecord
  validates :my_holiday, presence: true

  belongs_to :user
  belongs_to :group
end
