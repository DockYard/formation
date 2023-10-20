defmodule Formation.DeliFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Formation.Deli` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        customer: "some customer",
        items: "some items",
        name: "some name",
        price: 120.5,
        status: :draft
      })
      |> Formation.Deli.create_order()

    order
  end
end
