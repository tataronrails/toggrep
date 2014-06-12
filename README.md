# TOGGREP

## Setup Development/Testing Environment

    git clone git@github.com:tataronrails/toggrep.git
    cd toggrep
    cp config/database.yml.sample \
           config/database.yml
    cp config/email.yml.sample \
           config/email.yml
    # Edit yaml files
    bundle install
    bundle exec rake db:create db:migrate db:seed
    gem install zeus

## Running Development/Testing Environment

In separate terminal windows:

    redis run
    bundle exec guard start
    zeus start
    zeus console
    zeus server
    zeus rake resque:scheduler
    zeus rake resque:work
    zeus rspec spec

Resque server is available at:

    /resque
