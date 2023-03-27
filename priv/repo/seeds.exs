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

    database_users = Repo.all(User)

    Enum.each(database_users, fn user ->
      seed_crypto_1 = [
        %{coin: "Bitcoin", symbol: "BTC", amount: Enum.random(0..10), invested: Enum.random(0..10), user_id: user.id, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
        %{coin: "Ethereum", symbol: "ETH", amount: Enum.random(0..100), invested: Enum.random(0..100), user_id: user.id, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
        %{coin: "Litecoin", symbol: "LTC", amount: Enum.random(0..250), invested: Enum.random(0..250), user_id: user.id, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
        %{coin: "Ripple", symbol: "XRP", amount: Enum.random(0..50), invested: Enum.random(0..50), user_id: user.id, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
        %{coin: "Cardano", symbol: "ADA", amount: Enum.random(0..10000), invested: Enum.random(0..10000), user_id: user.id, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
        %{coin: "Dogecoin", symbol: "DOGE", amount: Enum.random(0..10000000), invested: Enum.random(0..10000000), user_id: user.id, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
        %{coin: "Polkadot", symbol: "DOT", amount: Enum.random(0..800), invested: Enum.random(0..800), user_id: user.id, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
      ]

      Repo.insert_all("cryptos", seed_crypto_1)
    end)

    # user = Repo.all(from u in User, inner_join: c in Crypto, on: u.id == c.user_id, select: %{name: u.name, user_id: u.id, crypto: c.id, coin: c.coin})
    # IO.inspect(user)
  end
end


Seed_data.seed()
