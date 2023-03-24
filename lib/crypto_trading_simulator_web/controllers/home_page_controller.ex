defmodule CryptoTradingSimulatorWeb.HomePageController do
  use CryptoTradingSimulatorWeb, :controller
  # alias CryptoTradingSimulator.{Repo, User, Crypto}
  require Logger

  # def index(conn, _params) do
  #   render(conn, :index)
  # end

  # def show(conn, %{"id" => id}) do
  #   user = Repo.get(User, id)
  #   render(conn, "show.html", user: user)
  # end

  def show(conn, %{"id" => id}) do
    render(conn, :show, id: id)
  end

end
