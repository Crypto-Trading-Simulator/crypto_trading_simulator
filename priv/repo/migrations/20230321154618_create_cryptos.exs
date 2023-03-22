defmodule CryptoTradingSimulator.Repo.Migrations.CreateCryptos do
  use Ecto.Migration

  def change do
    create table(:cryptos) do
      add :coin, :string
      add :amount, :float
      add :invested, :float
      add :symbol, :string

      timestamps()
    end
  end
end
