require 'database_cleaner'
require 'faker'

p 'Seeds:Start'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

p 'Users'

User.skip_callback(:save, :before, :sync_toggl_user!)

m = User.new(
    email: 'tataronrails+dev+manager@gmail.com',
    password: '12345678',
    toggl_api_key: Faker::Lorem.characters(32)
)
m.save!

w = User.new(
    email: 'tataronrails+dev+worker@gmail.com',
    password: '12345678',
    toggl_api_key: Faker::Lorem.characters(32)
)
w.save!

a = User.new(
    email: 'tataronrails+dev+admin@gmail.com',
    password: '12345678',
    toggl_api_key: Faker::Lorem.characters(32),
    admin: true
)
a.save!

p 'TogglUsers'

[m, w, a].each do |u|
  u.toggl_user.update_attributes(
      uid: Faker::Number.number(6),
      email: Faker::Internet.email,
      fullname: Faker::Name.name
  )
end

p 'Agreements'

past_date_range = [Date.today.prev_week.at_beginning_of_week, Date.today.prev_week.at_end_of_week]
current_date_range = [Date.today.at_beginning_of_week, Date.today.at_end_of_week]


p 'Seeds:End'