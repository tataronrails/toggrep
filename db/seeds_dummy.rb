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

[past_date_range, current_date_range].each do |date|
  Agreement::STATES.each do |state|
    Agreement.create(
        manager: m,
        worker: w,
        project_id: Faker::Number.number(7),
        limit_min: 35,
        limit_max: 40,
        state: state,
        started_at: date[0],
        ended_at: date[1]
    )
  end
end

p 'Seeds:End'