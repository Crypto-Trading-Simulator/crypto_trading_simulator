defmodule CryptoTradingSimulator.Repo.Migrations.CreateCryptos do
  use Ecto.Migration

  def change do
    create table(:cryptos) do
      add :coin, :string
      add :amount, :float
      add :symbol, :string
      add :user_id, references("users")

      timestamps()
    end
  end
end
