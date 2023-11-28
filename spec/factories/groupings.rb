FactoryBot.define do
  factory :grouping do
    leave_group {false}
    group_id {1}
    user_id {1}
  end
  factory :second_grouping, class: Grouping do
    leave_group {false}
    group_id {1}
    user_id {2}
  end
  factory :third_grouping, class: Grouping do
    leave_group {false}
    group_id {1}
    user_id {3}
  end
  factory :fourth_grouping, class: Grouping do
    leave_group {false}
    group_id {2}
    user_id {1}
  end
  factory :fifth_grouping, class: Grouping do
    leave_group {false}
    group_id {2}
    user_id {2}
  end
  factory :sixth_grouping, class: Grouping do
    leave_group {true}
    group_id {3}
    user_id {2}
  end
end
