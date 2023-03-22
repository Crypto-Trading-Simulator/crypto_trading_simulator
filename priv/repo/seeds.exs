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

import Ecto.Query

defmodule Seed_data do
  alias Plug.Crypto
  alias CryptoTradingSimulator.User, as: User
  alias CryptoTradingSimulator.Crypto, as: Crypto
  alias CryptoTradingSimulator.Repo, as: Repo

  def seed do
    #empty Crypto seed table
    Repo.delete_all(Crypto)

    #empty User seed table
    Repo.delete_all(User)

    # Create some users
    seed_users = [
      %{name: "Alice", email: "alice@example.com", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
      %{name: "Bob", email: "bob@example.com", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
      %{name: "Charlie", email: "charlie@example.com", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
      %{name: "David", email: "david@example.com", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
      %{name: "Emma", email: "emma@example.com", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
      %{name: "Frank", email: "frank@example.com", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
      %{name: "Grace", email: "grace@example.com", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
      %{name: "Henry", email: "henry@example.com", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
      %{name: "Isabel", email: "isabel@example.com", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
      %{name: "John", email: "john@example.com", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
    ]

    #Repo.insert!(%User{name: "Alice", email: "alice@example.com"})
    Repo.insert_all("users", seed_users)




    #Create some cryptos for user1
    seed_crypto = [
      %{coin: "Bitcoin", symbol: "BTC", amount: 1.0, invested: 1000.0, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
      %{coin: "Ethereum", symbol: "ETH", amount: 2.0, invested: 2000.0, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()}
    ]



    Repo.insert_all("cryptos", seed_crypto)

    #Repo.get(User)
    #drop_if_exists table("users")
  end
end


Seed_data.seed()
