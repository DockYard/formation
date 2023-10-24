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
        name: "some name",
        status: :draft,
        items: [],
        customer: "some customer",
        price: 120.5
      })
      |> Formation.Deli.create_order()

    order
  end
end
