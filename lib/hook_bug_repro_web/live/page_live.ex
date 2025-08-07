defmodule HookBugReproWeb.PageLive do
  require Logger

  use HookBugReproWeb, :live_view
  alias HookBugReproWeb.Router.Helpers, as: Routes
  alias HookBugReproWeb.Components.Item

  @all_items [
    "Item 1",
    "Item 2"
  ]

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:selected_items, [])
      |> assign(:filter_options, @all_items)

    {:ok, socket}
  end

  @impl true
  def handle_params(_, _, socket) do
    selected_items =
      if socket.assigns.selected_items != [] do
        Enum.filter(@all_items, &(&1 in socket.assigns.selected_items))
      else
        @all_items
      end

    {:noreply,
     socket
     |> assign(:selected_items, selected_items)
     |> assign(:assign_from_top_live_view, selected_items)}
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
        assign_from_top_live_view={@assign_from_top_live_view}
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

    socket =
      case params["value"] do
        nil ->
          selected = List.delete(selected, clicked_id)
          assign(socket, selected_items: selected)

        value ->
          selected = selected ++ [value]
          assign(socket, selected_items: selected)
      end

    {:noreply, push_patch(socket, to: "/")}
  end

  def handle_event("page_position_update", _params, socket) do
    Process.sleep(200)
    Logger.info("*** Hook event received")

    {:noreply, socket}
  end
end
