defmodule AsyncPublishing.ContentItemChannel do
  use Phoenix.Channel

  def join("content_items:index", _auth_msg, socket) do
    workflow_actions = AsyncPublishing.WorkflowActionRepository.all

    # Authorise all editors.  May later require auth tokens etc.
    {:ok, workflow_actions, socket}
  end

  def join("content_items:" <> content_id, _auth_msg, socket) do
    workflow_actions = AsyncPublishing.WorkflowActionRepository.get(content_id)

    # Authorise all editors.  May later require auth tokens etc.
    {:ok, workflow_actions, socket}
  end
end
