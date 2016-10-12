[![Build Status](https://travis-ci.org/dmitryrck/organize2.svg?branch=master)](https://travis-ci.org/dmitryrck/organize2)
[![Code Climate](https://codeclimate.com/github/dmitryrck/organize2/badges/gpa.svg)](https://codeclimate.com/github/dmitryrck/organize2)
[![Test Coverage](https://codeclimate.com/github/dmitryrck/organize2/badges/coverage.svg)](https://codeclimate.com/github/dmitryrck/organize2/coverage)
[![Issue Count](https://codeclimate.com/github/dmitryrck/organize2/badges/issue_count.svg)](https://codeclimate.com/github/dmitryrck/organize2)

# Running

    % bundle install
    % foreman

# Backup from Heroku

Create a backup:

    % heroku pg:backups capture

Download backup:

    % wget $(heroku pg:backups public-url) -O latest.dump

And to restore:

    % pg_restore -O -d organize2_development latest.dump
