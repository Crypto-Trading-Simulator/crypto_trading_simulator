# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CryptoTradingSimulator.Repo.insert!(%CryptoTradingSimulator.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule do
  alias CryptoTradingSimulator.{User, Crypto}
  alias CryptoTradingSimulator.Repo

  def seed do
    # Create some users
    user1 = %User{name: "Alice", email: "alice@example.com"}
    user2 = %User{name: "Bob", email: "bob@example.com"}
    Repo.insert_all([user1, user2], returning: [:id])

    # Create some cryptos for user1
    crypto1 = %Crypto{coin: "Bitcoin", symbol: "BTC", amount: 1.0, invested: 1000.0, user_id: user1.id}
    crypto2 = %Crypto{coin: "Ethereum", symbol: "ETH", amount: 2.0, invested: 2000.0, user_id: user1.id}
    Repo.insert_all([crypto1, crypto2])
  end
end
