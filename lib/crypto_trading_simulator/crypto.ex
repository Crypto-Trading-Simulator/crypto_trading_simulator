defmodule CryptoTradingSimulator.Crypto do
  use Ecto.Schema
  import Ecto.Changeset
  alias CryptoTradingSimulator.User

  schema "cryptos" do
    field :coin, :string
    field :amount, :float
    field :symbol, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(crypto, attrs) do
    crypto
    |> cast(attrs, [:coin, :amount, :symbol])
    |> validate_required([:coin, :amount, :symbol])
  end
end
