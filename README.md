# Running

    % bundle install
    % foreman

# Backup from Heroku

Create a backup:

    % heroku pg:backups capture

Download backup:

    % curl -o latest.dump `heroku pg:backups public-url`

And to restore:

    % pg_restore -O -d organize2_development latest.dump
