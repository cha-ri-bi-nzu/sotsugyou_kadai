class DesiredHoliday < ApplicationRecord
  validates :my_holiday, presence: true

  scope :group_data, -> (group_id) {where(group_id: group_id)}

  belongs_to :user
  belongs_to :group
end
