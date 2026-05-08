# GameBacklog

## Prerequisites

This project requires PostgreSQL. The easiest way to run it locally is with Docker:

```bash
docker run --name game-backlog-postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  -d postgres
```

Useful container commands:

* **Stop:** `docker stop game-backlog-postgres`
* **Start again:** `docker start game-backlog-postgres`
* **Remove:** `docker rm -f game-backlog-postgres`

## Getting started

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
