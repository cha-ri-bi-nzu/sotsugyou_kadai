class Group < ApplicationRecord
  has_many :groupings, dependent: :destroy
  has_many :users, through: :groupings, source: :user
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :sesired_holidays, dependent: :destroy
  has_many :attendances, dependent: :destroy
end
