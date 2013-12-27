FactoryGirl.define do

  sequence :password do |n|
    'password'
  end

  sequence :email do |n|
    Faker::Internet.email
  end

  sequence :fullname do |n|
    Faker::Name.name
  end

  sequence :uid do |n|
    rand(1e5..2e5).to_i
  end

  sequence :toggl_api_key do |n|
    SecureRandom.hex
  end

end
