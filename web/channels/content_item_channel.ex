defmodule AsyncPublishing.ContentItemChannel do
  use Phoenix.Channel

  def join("content_items:" <> content_id, _auth_msg, socket) do
    # Authorise all editors.  May later require auth tokens etc.
    {:ok, socket}
  end
end
