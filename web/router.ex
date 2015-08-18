defmodule AsyncPublishing.Router do
  use AsyncPublishing.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AsyncPublishing do
    pipe_through :browser

    resources "/content-items", ContentItemController, except: [:create, :edit, :new]
  end

  scope "/api", AsyncPublishing do
    pipe_through :api

    post "/content-items", ContentItemController, :create
  end
end
