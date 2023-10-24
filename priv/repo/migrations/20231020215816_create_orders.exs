defmodule Formation.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :customer, :string
      add :items, :jsonb, default: "[]"
      add :name, :string
      add :price, :float
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
