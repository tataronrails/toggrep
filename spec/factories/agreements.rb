FactoryGirl.define do

  factory :agreement do

    # association :manager, factory: :user
    # association :worker, factory: :user

    project_id { generate(:uid) }
    limit_min { rand(10..40) }
    limit_max { rand(limit_min..40) }
    started_at { Date.today.next_week.at_beginning_of_week }
    ended_at   { Date.today.next_week.at_end_of_week }
    state 'proposed'

  end

end
