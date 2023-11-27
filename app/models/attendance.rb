class Attendance < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  validates :working_day, presence: true
  validates :working_status_id, presence: true

  scope :group_data -> (group_id){where(group_id: group_id)}
  scope :month_data -> (month){where("working_day >= ?", Date.parse("#{month.beginning_of_month}")).where("working_day <= ?", Date.parse("#{month.end_of_month}"))}

  belongs_to :user
  belongs_to :group
  belongs_to :working_status
end
