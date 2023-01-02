[![Code Climate](https://codeclimate.com/github/dmitryrck/organize2/badges/gpa.svg)](https://codeclimate.com/github/dmitryrck/organize2)
[![Issue Count](https://codeclimate.com/github/dmitryrck/organize2/badges/issue_count.svg)](https://codeclimate.com/github/dmitryrck/organize2)
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

# Running

```terminal
$ cp docker-compose.yml.sample docker-compose.yml
```

Edit `docker-compose.yml` according to your needs, for example: remove heroku
configuration if you will not use heroku.

```terminal
$ cp config/database.yml.sample config/database.yml
$ docker-compose build && docker-compose pull
$ docker-compose run --rm -u root web bash -c "mkdir -p /bundle/vendor && chown ruby /bundle/vendor"
$ docker-compose run --rm web bundle install
$ docker-compose run --rm web bundle exec rake db:create
$ docker-compose run --rm web bundle exec rake db:migrate
```

# Backup from Heroku

## Auth

```terminal
$ docker run --rm -it -v heroku_home:/root dmitryrck/heroku login
```

## Backup

Create a backup:

```terminal
$ docker run --rm -v heroku_home:/root dmitryrck/heroku heroku pg:backups capture -a app-name-1234
```

Download backup:

```terminal
$ wget $(docker run --rm -v heroku_home:/root dmitryrck/heroku heroku pg:backups public-url -a app-name-1234) -O latest.dump
```

# Restore backup

```terminal
$ docker-compose run --rm web bundle exec rake db:drop
$ docker-compose run --rm web bundle exec rake db:create
$ docker-compose run --rm db pg_restore -U postgres -h db -O -d organize2_development < /app/latest.dump
```
