class Attendance < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  validates :working_day, presence: true
  validates :working_status_id, presence: true

  belongs_to :user
  belongs_to :group
  belongs_to :working_status
end
