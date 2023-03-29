defmodule CryptoTradingSimulatorWeb.PortfolioPageController do
  use CryptoTradingSimulatorWeb, :controller
  alias CryptoTradingSimulator.{Repo, User, Crypto}
  require Logger

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)|> Repo.preload(:cryptos)
    user_symbols = user.cryptos |> Enum.map(&(&1.symbol))
    user_amounts = user.cryptos |> Enum.map(&(&1.amount))
    total_portfolio_value = Enum.zip(user_symbols, user_amounts)
    |> Enum.map(fn {x, y} ->
      response = HTTPoison.get!("https://min-api.cryptocompare.com/data/price?fsym=#{x}&tsyms=GBP")
      crypto_price = elem(Enum.at(Poison.decode!(response.body), 0), 1)
      crypto_price * y
    end)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
    render(conn, "show.html",
      user: user,
      user_coin: user_symbols,
      total_portfolio_value: total_portfolio_value
      )
  end
end
