defmodule DemoElixirAshWeb.Items.IndexLive do
  use DemoElixirAshWeb, :live_view

  require Logger

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Items")

    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    # items = DemoElixirAsh.MyDomain.items_read!()
    items = DemoElixirAsh.MyDomain.Item
    |> Ash.Query.for_read(:read)
    |> Ash.read!()

    socket =
      socket
      |> assign(:page_title, "Items")
      |> assign(:items, items)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        {@page_title}
        <:actions>
          <.button
            navigate={~p"/items/new"}
          >
            New
          </.button>
        </:actions>
      </.header>

      <%= if @items == [] do %>
        <div>
          None.
        </div>
      <% else %>
        <ul>
          <li :for={item <- @items}>
            <.render_item item={item} />
          </li>
        </ul>
      <% end %>
    </Layouts.app>
    """
  end

  def render_item(assigns) do
    ~H"""
    <.link
      navigate={~p"/items/#{@item.id}"}
      data-role="item-name"
    >
      {@item.name}
    </.link>
    """
  end

end
