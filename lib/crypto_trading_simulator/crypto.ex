defmodule CryptoTradingSimulator.Crypto do
  use Ecto.Schema
  import Ecto.Changeset
  alias CryptoTradingSimulator.User

  schema "cryptos" do
    field :coin, :string
    field :amount, :float
    field :invested, :float
    field :symbol, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(crypto, attrs) do
    crypto
    |> cast(attrs, [:coin, :amount, :invested, :symbol])
    |> validate_required([:coin, :amount, :invested, :symbol])
  end
end
