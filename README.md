[![Build Status](https://travis-ci.org/dmitryrck/organize2.svg?branch=master)](https://travis-ci.org/dmitryrck/organize2)
[![Code Climate](https://codeclimate.com/github/dmitryrck/organize2/badges/gpa.svg)](https://codeclimate.com/github/dmitryrck/organize2)
[![Test Coverage](https://codeclimate.com/github/dmitryrck/organize2/badges/coverage.svg)](https://codeclimate.com/github/dmitryrck/organize2/coverage)
[![Issue Count](https://codeclimate.com/github/dmitryrck/organize2/badges/issue_count.svg)](https://codeclimate.com/github/dmitryrck/organize2)

# Running

    % bundle install
    % foreman

# Running (Docker)

    % cp docker-compose.yml.sample docker-compose.yml
    % cp config/database.yml.sample config/database.yml
    % docker-compose build
    % docker-compose run --rm web rake db:create
    % docker-compose run --rm web rake db:migrate

# Backup from Heroku

Create a backup:

    % heroku pg:backups capture

Download backup:

    % wget $(heroku pg:backups public-url) -O latest.dump

# Restore backup

And to restore:

    % pg_restore -O -d organize2_development latest.dump

# Restore backup (Docker)

    % docker-compose run --rm web rake db:drop
    % docker-compose run --rm web rake db:create
    % docker-compose run --rm web pg_restore -U postgres -h db -O -d organize2_development /app/latest.dump
