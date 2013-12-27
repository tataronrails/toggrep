FactoryGirl.define do

  factory :user do

    email
    password
    password_confirmation { password }
    toggl_api_key

    after(:build) do |user|
      user.class.skip_callback(:save, :before, :build_toggl_user)
      user.class.skip_callback(:save, :before, :sync_toggl_user!)
      user.toggl_user = build(:toggl_user)
    end

    trait :superuser do
      admin true
    end

  end

end
