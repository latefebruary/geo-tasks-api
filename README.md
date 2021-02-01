# Mini

## Installation

Run these commands in order to build application and create database

```elixir
mix do deps.get, deps.compile, compile

mix ecto.create
```

Make sure PostGIS extension to the database is installed.
```
psql mini_repo -c 'CREATE EXTENSION postgis;'
```

```elixir
mix ecto.migrate

mix run --no-halt
```



