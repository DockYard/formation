defmodule Formation.Deli.Order do
  use Ecto.Schema
  import Ecto.Changeset
  @permitted [:name, :customer, :price, :status]
  @required [:name, :customer]
  schema "orders" do
    field :name, :string
    field :status, Ecto.Enum, values: [:draft, :pending, :completed, :canceled]
    field :customer, :string
    field :price, :float

    embeds_many :items, Formation.Deli.Item, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @permitted)
    |> cast_embed(:items,
      sort_param: :items_sort,
      drop_param: :items_drop
    )
    |> validate_required(@required)
  end
end
