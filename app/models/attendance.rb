require "date"

class Attendance < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :user
  belongs_to :group
  belongs_to_active_hash :working_status
end
