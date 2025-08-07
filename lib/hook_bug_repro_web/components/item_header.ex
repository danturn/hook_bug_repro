defmodule HookBugReproWeb.Components.ItemHeader do
  use HookBugReproWeb, :live_component

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:item, assigns.item)
     |> assign_async(
       :async_assign,
       fn ->
         {:ok, %{async_assign: :assign}}
       end,
       reset: true
     )}
  end

  def render(assigns) do
    ~H"""
    <div id={"header-#{@item}"}>
      <.async_result assign={@async_assign}>
        <:loading>
          <div id={@item} class="border border-y-0 bg-red-500 text-white">
            {"#{@item} - I AM LOADING"}
          </div>
        </:loading>
        <div id={@item} class="border border-y-0 bg-green-500 text-white">
          {"#{@item} - I AM LOADED!"}
        </div>
      </.async_result>
    </div>
    """
  end
end
