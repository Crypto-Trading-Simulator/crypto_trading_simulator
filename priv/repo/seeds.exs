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

import Ecto.Query, warn: false
import CryptoTradingSimulator.Repo

defmodule Seed_data do
  alias Plug.Crypto
  alias CryptoTradingSimulator.User, as: User
  alias CryptoTradingSimulator.Crypto, as: Crypto
  alias CryptoTradingSimulator.Repo, as: Repo

  def seed do
    # Create some users
    #user1 = %{name: "Alice", email: "alice@example.com"}
    user2 = %User{name: "Bob", email: "bob@example.com"}

    user = Repo.get User, 5

    Repo.delete!(user)
    #IO.puts("steve")
    # Create some cryptos for user1
    #crypto1 = %{coin: "Bitcoin", symbol: "BTC", amount: 1.0, invested: 1000.0, user_id: user1.id}
    #crypto2 = %{coin: "Ethereum", symbol: "ETH", amount: 2.0, invested: 2000.0, user_id: user1.id}

  end
end


Seed_data.seed()
