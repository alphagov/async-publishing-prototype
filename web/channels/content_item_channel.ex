defmodule AsyncPublishing.ContentItemChannel do
  use Phoenix.Channel

  def join("content_items:" <> content_id, _auth_msg, socket) do
    # Authorise all editors.  May later require auth tokens etc.

    workflow_actions = AsyncPublishing.WorkflowActionRepository.get(content_id)

    {:ok, workflow_actions, socket}
  end
end
