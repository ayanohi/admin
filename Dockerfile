FROM ruby:2.7

# nodejsとmysql-client (default-mysql-client) のインストール
RUN apt-get update -qq && apt-get install -y curl apt-transport-https wget nodejs default-mysql-client

# Yarn のインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && apt-get install -y yarn

RUN mkdir /admin
WORKDIR /admin
COPY Gemfile /admin/Gemfile
COPY Gemfile.lock /admin/Gemfile.lock
RUN bundle install
COPY . /admin

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]