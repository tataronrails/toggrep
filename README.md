# TOGGREP

## Setup Development Environment

Clone repository

    git clone git@github.com:tataronrails/toggrep.git

Switch to project dir

    cd toggrep

Install all required gems with bundler

    bundle install

Run rails server

    rails server

## Setup Testing Environment

We use zeus to speed up testing sice it preloads rails environment.
We also use guard to track file changes and run only needed tests instead of full suite.

Create database

    RAILS_ENV=test bundle exec rake db:create db:migrate

Install zeus

    gem install zeus

## Running Testing Environment

In separate terminal windows:

    bundle exec zeus start
    bundle exec guard start
    zeus rspec spec

## Автоматическая проверка работников на нарушения

### Запуск автоматической проверки

Чтобы запустить автоматическую проверку работников на нарушения, необходимо в консоли набрать:

    redis run
    rake resque:scheduler
    rake resque:work

После этого можно посмотреть статистику работы, набрав

    /resque

### Описание работы:

* Проверка проходит каждые 20 минут. Посмотреть можно в _config/rescue_schedule.yml_
* Сначало находятся все актуальные Agreements на сегодняшний день.
* Потом проверяют каждого работника в Agreement на все правила нарушений.
* в конце проверки создается запись в ViolationCheck с результатом проверки, если нарушение есть, то result = true.

### Модели и классы:

- ***ViolationRule*** - Правила нарушения.
    * Переменные:
        - **assert_each**: указывается как часто нужно проверять на это нарушение. Должно быть в формате '1.day', '2.hours'
        - **condition**: указывается код, которые потом читается с помощью instance_eval, например "user.time_entries.last >= 1.day.ago"
        - **description**: описание.
- ***ViolationCheck***: Результат проверки. Содержит в себе Agreement и ViolationRule.
- ***ViolationChecker***: Класс для выполнения проверок на нарушения. Содержит метод check, в котором есть входящий параметр 'user',
который используется при выполнении instance_eval.
- ***ViolationCheckerJob***: Используется для автоматической проверки.
