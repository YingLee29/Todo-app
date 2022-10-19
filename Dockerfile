FROM ruby:3.0.2

# Install necessary libs
RUN apt-get update -y && apt-get install -y apt-transport-https
RUN apt-get update -y && apt-get install -y \
  git-core \
  vim \
  nano \
  zlib1g-dev \
  build-essential \
  libssl-dev \
  default-mysql-client \
  cmake

# Install bundler version 2.2.30
RUN gem install bundler:2.2.30
RUN gem update --system

# Set up ENV
ENV LANG C.UTF-8
ENV BUNDLER_VERSION 2.2.30
ENV APP /todo-server-rails

RUN mkdir $APP
WORKDIR $APP
