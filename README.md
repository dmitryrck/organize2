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
