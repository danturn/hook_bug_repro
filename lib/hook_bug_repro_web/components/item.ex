defmodule HookBugReproWeb.Components.Item do
  use HookBugReproWeb, :live_component
  alias HookBugReproWeb.Components.ItemHeader

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:item, assigns.item)
     |> assign_unrendered_component_assigns()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id={"item-#{@item}"} phx-hook="PagePositionNotifier">
      <.live_component
        id={"item-header-#{@item}"}
        module={ItemHeader}
        item={@item}
      />
      <.unrendered_component :if={false} id="unrendered" any_assign={@any_assign} />
    </div>
    """
  end

  defp unrendered_component(_) do
    raise "SHOULD NOT BE CALLED"
  end

  defp assign_unrendered_component_assigns(socket) do
    socket
    |> assign(:any_assign, true)
    |> assign_async(
      :any_assign,
      fn ->
        {:ok, %{any_assign: true}}
      end
    )
  end
end
