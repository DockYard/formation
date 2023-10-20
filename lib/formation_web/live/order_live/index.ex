defmodule FormationWeb.OrderLive.Index do
  use FormationWeb, :live_view

  alias Formation.Deli
  alias Formation.Deli.Order

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :orders, Deli.list_orders())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Order")
    |> assign(:order, Deli.get_order!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Order")
    |> assign(:order, %Order{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end

  @impl true
  def handle_info({FormationWeb.OrderLive.FormComponent, {:saved, order}}, socket) do
    {:noreply, stream_insert(socket, :orders, order)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    order = Deli.get_order!(id)
    {:ok, _} = Deli.delete_order(order)

    {:noreply, stream_delete(socket, :orders, order)}
  end
end
