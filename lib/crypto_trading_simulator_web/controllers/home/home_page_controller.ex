defmodule CryptoTradingSimulatorWeb.HomePageController do
  use CryptoTradingSimulatorWeb, :controller
  alias CryptoTradingSimulator.{Repo, User, Crypto}
  alias CryptoTradingSimulator.Router.Helpers, as: Routes
  require Logger
  require HTTPoison
  require Poison
  import Phoenix.HTML



  def show(conn, %{"id" => id}) do
    response = HTTPoison.get!("https://min-api.cryptocompare.com/data/v2/news/?lang=EN")
    news_data = Poison.decode!(response.body)["Data"]
    response = HTTPoison.get!("https://min-api.cryptocompare.com/data/top/totalvolfull?limit=10&tsym=GBP")
    data = Poison.decode!(response.body)
    render(conn, "show.html",
      data: data,
      news_data: news_data,
      user_id: id,
    )
  end

end
