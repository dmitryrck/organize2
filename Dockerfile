from dmitryrck/ruby:2.7.2-prod

env \
  DATABASE_URL="postgres://postgres:password@host/notreal"

copy . /app

workdir /app

run \
  bundle config set without "development test" && \
  bundle install && \
  mkdir -p /app/log /app/tmp/pids && \
  bundle exec rake assets:precompile

ENTRYPOINT ["/app/docker-entrypoint.sh"]
