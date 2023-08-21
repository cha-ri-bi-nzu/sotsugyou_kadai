# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.create!(
  name: "adminmin",
  email: "admin@email.com",
  password: "adminadmin",
  admin: true
)

5.times do |n|
  User.create!(
      name: "user#{n+10}",
      email: "#{n+10}@email.com",
      password: "#{n+10}aaaaaa",
      admin: false
  )
end


Group.create!(
    name: "admin_group",
    owner_id: 1,
    invalid_group: false
)

5.times do |n|
  Group.create!(
      name: "group#{n+10}",
      owner_id: n+2,
      invalid_group: false
  )
end

5.times do |n|
  Group.create!(
      name: "group#{n+15}",
      owner_id: 1,
      invalid_group: true
  )
end


6.times do |n|
  Grouping.create!(
      user_id: n+1,
      group_id: n+1,
      leave_group: false
  )
end

6.times do |n|
  Grouping.create!(
      user_id: n+1,
      group_id: 6-n,
      leave_group: false
  )
end

2.times do |n|
  Grouping.create!(
    [
      {
        user_id: 1,
        group_id: 5-n,
        leave_group: true
      },
      {
        user_id: 2,
        group_id: 4-n,
        leave_group: true
      }
    ]
  )
end
