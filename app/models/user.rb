class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  def self.guest
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
      user.admin = false
    end
  end

  def self.admin_guest
    user = User.find_or_create_by!(email: 'admin_guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト管理者"
      user.admin = true
    end
  end
  
  has_many :groupings, dependent: :destroy
  has_many :groups, through: :groupings, source: :group
  has_many :groups, foreign_key: :owner_id
  has_many :sesired_holidays, dependent: :destroy
  has_many :attendances, dependent: :destroy
end
