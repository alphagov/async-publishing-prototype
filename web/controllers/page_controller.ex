defmodule AsyncPublishing.PageController do
  use AsyncPublishing.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
