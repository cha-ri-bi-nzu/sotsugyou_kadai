FactoryBot.define do
  factory :grouping do
    leave_group {false}
    group_id {group.id}
    user_id {user.id}
  end
  factory :second_grouping, class: Grouping do
    leave_group {false}
    group_id {group.id}
    user_id {second_user.id}
  end
  factory :third_grouping, class: Grouping do
    leave_group {false}
    group_id {group.id}
    user_id {3}
  end
  factory :fourth_grouping, class: Grouping do
    leave_group {false}
    group_id {second_group.id}
    user_id {user.id}
  end
  factory :fifth_grouping, class: Grouping do
    leave_group {false}
    group_id {second_group.id}
    user_id {second_user.id}
  end
  factory :sixth_grouping, class: Grouping do
    leave_group {true}
    group_id {3}
    user_id {second_user.id}
  end
end
