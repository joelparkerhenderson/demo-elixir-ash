defmodule DemoElixirAshWeb.PageController do
  use DemoElixirAshWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
