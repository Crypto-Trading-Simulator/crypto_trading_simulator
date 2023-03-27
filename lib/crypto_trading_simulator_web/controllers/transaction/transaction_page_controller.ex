defmodule CryptoTradingSimulatorWeb.TransactionPageController do
  use CryptoTradingSimulatorWeb, :controller
  alias CryptoTradingSimulator.{Repo, User, Crypto}
  alias CryptoTradingSimulator.Router.Helpers, as: Routes
  require Logger
  require HTTPoison
  require Poison
  import Phoenix.HTML

  # def index(conn, _params) do
  #   render(conn, :index)
  # end

  # def show(conn, %{"id" => id}) do
  #   user = Repo.get(User, id)
  #   render(conn, "show.html", user: user)
  # end

  def buy(_conn, %{"id" => id, "symbol" => symbol, "amount" => _amount}) do
    response = HTTPoison.get!("https://min-api.cryptocompare.com/data/price?fsym=#{symbol}&tsyms=GBP")
    data = Poison.decode!(response.body)
    user = Repo.get(User, id) |> Repo.preload(:cryptos)
    user_coins = user.cryptos |> Enum.map(&(&1.symbol))
    exists = Enum.any?(user_coins, fn coin_symbol -> coin_symbol == symbol end)
    IO.puts(exists)
  end


  def show(conn, %{"id" => id, "symbol" => symbol}) do
    response = HTTPoison.get!("https://min-api.cryptocompare.com/data/price?fsym=#{symbol}&tsyms=GBP")
    data = Poison.decode!(response.body)
    user = Repo.get(User, id)|> Repo.preload(:cryptos)
    render(conn, "show.html", data: data, user_id: id, html: Phoenix.HTML, routes: CryptoTradingSimulatorWeb.Router.Helpers)
  end
end
