[![Code Climate](https://codeclimate.com/github/dmitryrck/organize2/badges/gpa.svg)](https://codeclimate.com/github/dmitryrck/organize2)
[![Test Coverage](https://codeclimate.com/github/dmitryrck/organize2/badges/coverage.svg)](https://codeclimate.com/github/dmitryrck/organize2/coverage)
[![Issue Count](https://codeclimate.com/github/dmitryrck/organize2/badges/issue_count.svg)](https://codeclimate.com/github/dmitryrck/organize2)
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

# Running

```terminal
$ cp docker-compose.yml.sample docker-compose.yml
```

Edit `docker-compose.yml` according to your needs.

```terminal
$ cp config/database.yml.sample config/database.yml
$ docker-compose build && docker-compose pull
$ docker-compose run --rm -u root web bash -c "mkdir -p /bundle/vendor && chown ruby /bundle/vendor"
$ docker-compose run --rm web bundle install
$ docker-compose run --rm web bundle exec rake db:create
$ docker-compose run --rm web bundle exec rake db:migrate
```

# Deprecated notices

* The table `cards` is deprecated
  * See https://github.com/dmitryrck/organize2/pull/70 for more details
* The column `movements.chargeable_type` is deprecated
  * Though it is deprecated this relation is still a fully functional polymorphic association
  * See https://github.com/dmitryrck/organize2/pull/70 and https://github.com/dmitryrck/organize2/issues/41 for more details
