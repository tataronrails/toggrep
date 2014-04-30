namespace :db do

  task 'seed:dummy' => :environment do
    load 'db/seeds_dummy.rb'
  end

end