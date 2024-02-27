FROM ruby:2.6.8-alpine3.13 AS base

# Author's information
LABEL maintainer="jean.toure@ngser.com"

# Install dependances
ENV BUNDLER_VERSION=2.0.2

RUN apk add --update --no-cache \
  binutils-gold \
  build-base \
  curl \
  file \
  g++ \
  gcc \
  git \
  less \
  libstdc++ \
  libffi-dev \
  libc-dev \
  linux-headers \
  libxml2-dev \
  libxslt-dev \
  libgcrypt-dev \
  make \
  netcat-openbsd \
  openssl \
  pkgconfig \
  postgresql-dev \
  python3 \
  nodejs \
  yarn \
  tzdata

# This stage will be responsible for installing gems
FROM base AS dependencies

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Copy the gemfile and gemfile.lock so we can run bundle on it
# Install and run bundle to get the app ready
RUN gem install bundler
COPY Gemfile Gemfile.lock ./
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle config set without 'test' && \ 
    bundle check || bundle install --jobs=3 --retry=3

# We're back at the base stage
FROM base

# Set the working directory of everything to the directory we just made.
RUN adduser -h /home/ngser -D ngser
USER ngser
RUN mkdir /home/ngser/app
WORKDIR /home/ngser/app

# Copy over gems from the dependencies stage
COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/

# Finally, copy over the code
# This is where the .dockerignore file comes into play
# Note that we have to use `--chown` here
COPY --chown=ngser . ./

# Add a script to be executed every time the container starts.
ENTRYPOINT ["sh", "entrypoint.sh"]

# Expose port 3000 on the container
EXPOSE 3000

# Clear cache (optional)
# RUN bundle exec rake tmp:clear

# Run the application on port 3000
#CMD ["bundle", "exec", "puma"]
CMD ["bundle", "exec", "rails", "s", "-b","0.0.0.0", "-p", "3000"]
