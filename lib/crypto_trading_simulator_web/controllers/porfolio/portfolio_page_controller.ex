defmodule CryptoTradingSimulatorWeb.PortfolioPageController do
  use CryptoTradingSimulatorWeb, :controller
  alias CryptoTradingSimulator.{Repo, User, Crypto}
  require Logger
  import Ecto.Query

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

    img_url_fetch = HTTPoison.get!("https://min-api.cryptocompare.com/data/all/coinlist")
    img_url_data = Poison.decode!(img_url_fetch.body)
    full_img_data = img_url_data["Data"]

    render(conn, "show.html",
      full_img_data: full_img_data,
      user: user,
      user_coin: user_symbols,
      total_portfolio_value: total_portfolio_value
      )
  end
end
