FROM ruby:3.2.2

RUN set -eu && \
  apt-get update -y && \
  apt-get install -y --no-install-recommends \
    build-essential \
    git \
    curl \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/gem

RUN set -eu \
  && mkdir -p lib/graal_ffi \
  && echo "module GraalFFI\n  VERSION = \"0.1.0\"\nend\n" > lib/graal_ffi/version.rb

COPY bin/setup ./bin/
COPY Gemfile Gemfile.lock graal_ffi.gemspec ./

RUN set -eu \
  && bin/setup
