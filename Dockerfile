from ruby:2.3.1

env DEBIAN_FRONTEND noninteractive

run sed -i '/deb-src/d' /etc/apt/sources.list
run apt-get update
run apt-get install -y build-essential postgresql-client nodejs

env PHANTOMJS_VERSION 1.9.8

run wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -O- | tar xfj - -C /usr/local
run ln -s /usr/local/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs

workdir /tmp
copy Gemfile Gemfile
copy Gemfile.lock Gemfile.lock

run bundle install

workdir /app

cmd ["rails", "server", "-b", "0.0.0.0"]
