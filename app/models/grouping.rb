class Grouping < ApplicationRecord
  belongs_to :user
  belongs_to :group

  before_update GroupingCallback.new
end
