defmodule CryptoTradingSimulatorWeb.CoinViewPageController do
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


  def show(conn, %{"symbol" => symbol, "id" => id}) do
    response = HTTPoison.get!("https://min-api.cryptocompare.com/data/top/totalvolfull?limit=10&tsym=GBP")
    data = Poison.decode!(response.body)
    filtered_data = Enum.filter(data["Data"], fn x -> x["CoinInfo"]["Name"] == symbol end)
    render(conn, "show.html", data: filtered_data, user_id: id, html: Phoenix.HTML, routes: CryptoTradingSimulatorWeb.Router.Helpers)
  end

end
