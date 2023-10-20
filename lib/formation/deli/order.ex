defmodule Formation.Deli.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :name, :string
    field :status, Ecto.Enum, values: [:draft, :pending, :completed, :canceled]
    field :items, :string
    field :customer, :string
    field :price, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:name, :customer, :price, :status, :items])
    |> validate_required([:name, :customer, :price, :status, :items])
  end
end
