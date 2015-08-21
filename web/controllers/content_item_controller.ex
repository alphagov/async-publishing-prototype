defmodule AsyncPublishing.ContentItemController do
  use AsyncPublishing.Web, :controller

  alias AsyncPublishing.WorkflowActionRepository
  alias AsyncPublishing.TitleMap

  plug :scrub_params, "content_item" when action in [:create]

  def index(conn, _params) do
    ids_and_titles = Map.keys(WorkflowActionRepository.all)
    |> Enum.map(fn(id) -> {id, TitleMap.get(id)} end)

    render(conn, "index.html", ids_and_titles: ids_and_titles)
  end

  def show(conn, %{"id" => id}) do
    title = TitleMap.get(id)
    workflow_actions = WorkflowActionRepository.get(id)

    render(conn, "show.html", id: id, title: title, workflow_actions: workflow_actions)
  end

  def update(conn, %{"id" => id, "action" => action}) do
    details = WorkflowActionRepository.get(id)[action]
    |> Map.put("state", "complete")

    WorkflowActionRepository.assign(id, action, details)

    updated_actions = %{}
    |> Map.put(action, details)
    AsyncPublishing.Endpoint.broadcast!("content_items:#{id}", "update", updated_actions)

    updated_actions_by_id = %{}
    |> Map.put(id, updated_actions)
    AsyncPublishing.Endpoint.broadcast!("content_items:index", "update", updated_actions_by_id)

    conn
    |> put_flash(:info, "#{action} triggered successfully.")
    |> redirect(to: content_item_path(conn, :show, id))
  end

  # API endpoint
  def create(conn, %{"content_item" => content_item_params}) do
    TitleMap.put(content_item_params["id"], content_item_params["title"])

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
