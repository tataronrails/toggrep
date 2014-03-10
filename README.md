# TOGGREP

## Setup Development/Testing Environment

    git clone git@github.com:tataronrails/toggrep.git
    cd toggrep
    bundle install
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
