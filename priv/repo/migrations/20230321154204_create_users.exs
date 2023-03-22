defmodule CryptoTradingSimulator.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: true) do
      add :name, :string
      add :email, :string

      timestamps()
    end
  end
end
