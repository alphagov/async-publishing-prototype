defmodule AsyncPublishing.WorkflowActionRepository do
  def start_link do
    {:ok, agent} = Agent.start_link(fn -> HashDict.new end)
    Process.register(agent, :workflow_action_repository)
    {:ok, agent}
  end

  def assign(content_id, action, details) do
    Agent.update(:workflow_action_repository, fn repository ->
      defaults = %{}
      |> Dict.put(action, details)

      HashDict.update(repository, content_id, defaults, fn(workflow_actions) ->
        Dict.put(workflow_actions, action, details)
      end)
    end)
  end

  def get(content_id) do
    case Agent.get(:workflow_action_repository, &HashDict.get(&1, content_id)) do
      nil -> %{}
      workflow_actions -> workflow_actions
    end
  end
end
