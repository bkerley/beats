FROM ruby:3-alpine AS builder
RUN apk add alpine-sdk nodejs
RUN mkdir /beats
WORKDIR /beats
ADD Gemfile /beats
RUN bundle install

FROM ruby:3-alpine
RUN apk add nodejs
RUN mkdir /beats
RUN adduser -D beats
WORKDIR /beats
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --chown=beats . /beats/
COPY --chown=beats --from=builder /beats/Gemfile* /beats/
CMD bundle exec puma -b tcp://0:8080
