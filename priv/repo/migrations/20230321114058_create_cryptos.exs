defmodule CryptoTradingSimulator.Repo.Migrations.CreateCryptos do
  use Ecto.Migration

  def change do
    create table(:cryptos) do
      add :coin, :string
      add :symbol, :string
      add :amount, :float
      add :invested, :float

      timestamps()
    end
  end
end
