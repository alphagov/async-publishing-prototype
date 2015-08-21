defmodule AsyncPublishing.TitleMap do
  def start_link do
    {:ok, agent} = Agent.start_link(fn -> %{} end)
    Process.register(agent, :title_map)
    {:ok, agent}
  end

  def put(content_id, title) do
    Agent.update(:title_map, &Map.put(&1, content_id, title))
  end

  def get(content_id) do
    Agent.get(:title_map, &Map.get(&1, content_id))
  end
end
