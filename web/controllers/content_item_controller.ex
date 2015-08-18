defmodule AsyncPublishing.ContentItemController do
  use AsyncPublishing.Web, :controller

  alias AsyncPublishing.WorkflowActionRepository

  plug :scrub_params, "content_item" when action in [:create]

  def index(conn, _params) do
    content_item_ids = Map.keys(WorkflowActionRepository.all)
    render(conn, "index.html", content_item_ids: content_item_ids)
  end

  def show(conn, %{"id" => id}) do
    workflow_actions = WorkflowActionRepository.get(id)
    render(conn, "show.html", id: id, workflow_actions: workflow_actions)
  end

  def update(conn, %{"id" => id, "action" => action}) do
    details = WorkflowActionRepository.get(id)[action]
    |> Map.put("state", "complete")

    WorkflowActionRepository.assign(id, action, details)

    updated_actions = %{}
    |> Map.put(action, details)

    AsyncPublishing.Endpoint.broadcast!("content_items:#{id}", "update", updated_actions)

    conn
    |> put_flash(:info, "#{action} triggered successfully.")
    |> redirect(to: content_item_path(conn, :show, id))
  end

  # API endpoint
  def create(conn, %{"content_item" => content_item_params}) do
    Enum.each(content_item_params["workflow_actions"], fn({action, details}) ->
      WorkflowActionRepository.assign(
        content_item_params["id"],
        action,
        details
      )
    end)

    json conn, %{errors: []}
  end
end
