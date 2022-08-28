FROM ruby:3-alpine AS builder
RUN apk add alpine-sdk
RUN mkdir /beats
WORKDIR /beats
ADD Gemfile /beats
RUN bundle install

FROM ruby:3-alpine

RUN mkdir /beats

WORKDIR /beats
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
ADD * /beats/
COPY --from=builder /beats/Gemfile* /beats/
CMD bundle exec puma -b tcp://0:8080
