defmodule CryptoTradingSimulator.Crypto do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cryptos" do
    field :coin, :string
    field :amount, :float
    field :invested, :float
    field :symbol, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(crypto, attrs) do
    crypto
    |> cast(attrs, [:coin, :amount, :invested, :symbol, :user_id])
    |> validate_required([:coin, :amount, :invested, :symbol, :user_id])
  end
end
