FactoryBot.define do
  factory :group do
    id {100}
    name {'test_group'}
    owner_id {3}
    invalid_group {false}
  end
  factory :second_group, class: Group do
    id {101}
    name {'group_name2'}
    owner_id {2}
    invalid_group {false}
  end
  factory :third_group, class: Group do
    id {102}
    name {'group_name3'}
    owner_id {2}
    invalid_group {true}
  end
end
