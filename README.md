# Async publishing prototype

This is a Phoenix/Elixir application acting as a backend for prototyping the
display of publish-in-progress information within publishers.

It is a prototype itself and is explicitly not long-lived code.  Test coverage
should not be trusted and this application will be deleted or archived when its
purpose has been served.

It uses Phoenix channels to communicate via push to the publishers over websockets,
as seen in the `async-publishing-prototype` branch of Policy Publisher.

## Dependencies

System dependencies can be found at http://www.phoenixframework.org/docs/installation

There are no application dependencies, however this application is a dependency
of the `async-publishing-prototype` branch of Policy Publisher and the Publishing API.

## Running the application

To start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. Start Phoenix endpoint with `mix phoenix.server`
  3. For an interactive console, start Phoenix with `iex -S mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Running the test suite

You can run the tests locally with `mix test`.
