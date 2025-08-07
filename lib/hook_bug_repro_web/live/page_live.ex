defmodule HookBugReproWeb.PageLive do
  use HookBugReproWeb, :live_view
  alias HookBugReproWeb.Components.Item

  @all_items [
    "Item 1",
    "Item 2"
  ]

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:selected_items, @all_items)
      |> assign(:filter_options, @all_items)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.multi_select id="multi-select" items={@filter_options} selected={@selected_items} />
    <div :for={item <- @selected_items}>
      <.live_component
        module={Item}
        id={"item-#{item}"}
        item={item}
      />
    </div>
    """
  end

  def multi_select(assigns) do
    ~H"""
    <div :for={item <- @items}>
      <label for={"item-select-#{item}"}>
        <input
          type="checkbox"
          phx-click="toggle_item"
          phx-value-clicked={item}
          id={"select-#{item}"}
          name="select"
          value={item}
          checked={item in @selected}
        />
        {item}
      </label>
    </div>
    """
  end

  @impl true
  def handle_event("toggle_item", params = %{"clicked" => clicked_id}, socket) do
    selected = socket.assigns.selected_items

    selected =
      case params["value"] do
        nil ->
          selected = List.delete(selected, clicked_id)

        value ->
          selected = selected ++ [value]
      end

    {:noreply, assign(socket, selected_items: Enum.sort(selected))}
  end

  def handle_event("page_position_update", _params, socket) do
    {:noreply, socket}
  end
end
