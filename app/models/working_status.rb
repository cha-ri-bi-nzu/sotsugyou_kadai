class WorkingStatus < ApplicationRecord
  self.data = [
    {id: 1, status: '休', working_times: 0}, 
    {id: 2, status: '希', working_times: 0}, 
    {id: 3, status: '出', working_times: 8}
  ]
end
