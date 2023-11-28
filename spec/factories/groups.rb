FactoryBot.define do
  factory :group do
    name {'test_group'}
    owner_id {1}
    invalid_group {false}
  end
  factory :second_group, class: Group do
    name {'group_name2'}
    owner_id {2}
    invalid_group {false}
  end
  factory :third_group, class: Group do
    name {'group_name3'}
    owner_id {2}
    invalid_group {true}
  end
end
