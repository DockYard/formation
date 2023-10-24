defmodule Formation.DeliTest do
  use Formation.DataCase

  alias Formation.Deli

  describe "orders" do
    alias Formation.Deli.Order

    import Formation.DeliFixtures

    @invalid_attrs %{name: nil, status: nil, items: nil, customer: nil, price: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Deli.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Deli.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{
        name: "some name",
        status: :draft,
        items: [],
        customer: "some customer",
        price: 120.5
      }

      assert {:ok, %Order{} = order} = Deli.create_order(valid_attrs)
      assert order.name == "some name"
      assert order.status == :draft
      assert order.items == []
      assert order.customer == "some customer"
      assert order.price == 120.5
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Deli.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()

      update_attrs = %{
        name: "some updated name",
        status: :pending,
        items: [],
        customer: "some updated customer",
        price: 456.7
      }

      assert {:ok, %Order{} = order} = Deli.update_order(order, update_attrs)
      assert order.name == "some updated name"
      assert order.status == :pending
      assert order.items == []
      assert order.customer == "some updated customer"
      assert order.price == 456.7
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Deli.update_order(order, @invalid_attrs)
      assert order == Deli.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Deli.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Deli.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Deli.change_order(order)
    end
  end
end
