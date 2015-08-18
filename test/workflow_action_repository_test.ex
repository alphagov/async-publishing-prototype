defmodule WorkflowActionRepositoryTest do
  use ExUnit.Case, async: false
  alias AsyncPublishing.WorkflowActionRepository

  setup do
    WorkflowActionRepository.reset
  end

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

  test "returns all content items" do
    WorkflowActionRepository.assign("1234-5689", "live_content_store", %{
      human_action: "Send to live content store",
      state: "incomplete",
    })

    WorkflowActionRepository.assign("0873-2938", "draft_content_store", %{
      human_action: "Send to draft content store",
      state: "complete",
    })

    assert WorkflowActionRepository.all == %{
      "1234-5689" => %{
        "live_content_store" => %{
          human_action: "Send to live content store",
          state: "incomplete",
        },
      },
      "0873-2938" => %{
        "draft_content_store" => %{
          human_action: "Send to draft content store",
          state: "complete",
        }
      }
    }
  end
end
