defmodule CryptoTradingSimulatorWeb.PortfolioPageController do
  use CryptoTradingSimulatorWeb, :controller
  alias CryptoTradingSimulator.{Repo, User, Crypto}
  require Logger

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)|> Repo.preload(:cryptos)

    render(conn, "show.html", user: user)
  end
end
