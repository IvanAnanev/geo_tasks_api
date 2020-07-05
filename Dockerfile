FROM bitwalker/alpine-elixir:1.10.3

RUN apk --update add alpine-sdk postgresql-client

ADD . /app

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app

EXPOSE 4000
CMD ["./bin/run.sh"]
