defmodule CryptoTradingSimulator.Crypto do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cryptos" do
    field :amount, :float
    field :coin, :string
    field :invested, :float
    field :symbol, :string

    belongs_to :user, CryptoTradingSimulator.User

    timestamps()
  end

  @doc false
  def changeset(crypto, attrs) do
    crypto
    |> cast(attrs, [:coin, :symbol, :amount, :invested])
    |> validate_required([:coin, :symbol, :amount, :invested])
  end
end
