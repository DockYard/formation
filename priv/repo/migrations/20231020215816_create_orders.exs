defmodule Formation.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :name, :string
      add :customer, :string
      add :price, :float
      add :status, :string
      add :items, :string

      timestamps(type: :utc_datetime)
    end
  end
end
