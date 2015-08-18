defmodule WorkflowActionRepositoryTest do
  use ExUnit.Case, async: true
  alias AsyncPublishing.WorkflowActionRepository

  test "adds workflow items for the content item" do
    content_id = "1234-5689"

    assert WorkflowActionRepository.get(content_id) == %{}

    WorkflowActionRepository.assign(content_id, "live_content_store", %{
      human_action: "Send to live content store",
      state: "incomplete",
    })

    assert WorkflowActionRepository.get(content_id) == %{
      "live_content_store" => %{
        human_action: "Send to live content store",
        state: "incomplete",
      }
    }

    WorkflowActionRepository.assign(content_id, "draft_content_store", %{
      human_action: "Send to draft content store",
      state: "complete",
    })

    assert WorkflowActionRepository.get(content_id) == %{
      "live_content_store" => %{
        human_action: "Send to live content store",
        state: "incomplete",
      },
      "draft_content_store" => %{
        human_action: "Send to draft content store",
        state: "complete",
      }
    }
  end
end
