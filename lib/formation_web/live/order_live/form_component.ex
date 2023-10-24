defmodule FormationWeb.OrderLive.FormComponent do
  use FormationWeb, :live_component

  alias Formation.Deli

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Formation Deli Order Form</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="order-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:customer]} type="text" label="Customer" />
        <.input field={@form[:price]} type="number" label="Price" step="any" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a value"
          options={Ecto.Enum.values(Formation.Deli.Order, :status)}
        />
        <% # Items %>
        <h2 class="pt-4 text-lg font-medium text-gray-900">Items</h2>
        <div class="mt-2 flex flex-col">
          <.inputs_for :let={item_f} field={@form[:items]}>
            <div class="mt-2 flex items-center justify-between gap-6">
              <input type="hidden" name="order[items_sort][]" value={item_f.index} />
              <.input field={item_f[:name]} type="text" label="Name" />
              <.input field={item_f[:price]} type="number" label="Price" step="any" />
              <.input field={item_f[:quantity]} type="number" label="Quantity" />
              <label>
                <input type="checkbox" name="order[items_drop][]" value={item_f.index} class="hidden" />
                <.icon
                  name="hero-x-mark"
                  class="w-8 h-8 relative top-4 bg-red-500 hover:bg-red-700 hover:cursor-pointer"
                />
              </label>
            </div>
          </.inputs_for>
        </div>
        <:actions>
          <label class={[
            "py-2 px-3 inline-block cursor-pointer bg-green-500 hover:bg-green-700",
            "rounded-lg text-center text-white text-sm font-semibold leading-6"
          ]}>
            <input type="checkbox" name="order[items_sort][]" class="hidden" /> Add Item
          </label>
          <.button phx-disable-with="Saving...">Save Order</.button>
        </:actions>
        <input type="hidden" name="order[items_drop][]" />
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{order: order} = assigns, socket) do
    changeset = Deli.change_order(order)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"order" => order_params}, socket) do
    changeset =
      socket.assigns.order
      |> Deli.change_order(order_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"order" => order_params}, socket) do
    save_order(socket, socket.assigns.action, order_params)
  end

  defp save_order(socket, :edit, order_params) do
    case Deli.update_order(socket.assigns.order, order_params) do
      {:ok, order} ->
        notify_parent({:saved, order})

        {:noreply,
         socket
         |> put_flash(:info, "Order updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_order(socket, :new, order_params) do
    case Deli.create_order(order_params) do
      {:ok, order} ->
        notify_parent({:saved, order})

        {:noreply,
         socket
         |> put_flash(:info, "Order created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
