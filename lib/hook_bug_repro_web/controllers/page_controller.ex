defmodule HookBugReproWeb.PageController do
  use HookBugReproWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
