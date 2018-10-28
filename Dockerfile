from ruby

env DEBIAN_FRONTEND=noninteractive \
  CHROMEDRIVER_VERSION=2.42 \
  NODE_VERSION=11.0.0

run sed -i "/deb-src/d" /etc/apt/sources.list && \
  wget -q -O- https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y build-essential libpq-dev postgresql-client google-chrome-stable unzip && \
  curl -sSL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" | tar xfJ - -C /usr/local --strip-components=1 && \
  wget -q http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
  unzip chromedriver_linux64.zip -d /usr/local/bin && rm chromedriver_linux64.zip && \
  wget -q -O- https://yarnpkg.com/latest.tar.gz | tar xfz - -C /opt && \
  mv /opt/yarn-v* /opt/yarn && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn && \
  chmod +x /usr/local/bin/chromedriver && \
  useradd -m -s /bin/bash -u 1000 ruby
