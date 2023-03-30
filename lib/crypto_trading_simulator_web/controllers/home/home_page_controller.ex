defmodule CryptoTradingSimulatorWeb.HomePageController do
  use CryptoTradingSimulatorWeb, :controller
  alias CryptoTradingSimulator.{Repo, User, Crypto}
  alias CryptoTradingSimulator.Router.Helpers, as: Routes
  require Logger
  require HTTPoison
  require Poison



  def show(conn, %{"id" => id}) do
    response = HTTPoison.get!("https://min-api.cryptocompare.com/data/v2/news/?lang=EN")
    news_data = Poison.decode!(response.body)["Data"]
    response = HTTPoison.get!("https://min-api.cryptocompare.com/data/top/totalvolfull?limit=10&tsym=GBP")
    data = Poison.decode!(response.body)

    img_url_fetch = HTTPoison.get!("https://min-api.cryptocompare.com/data/all/coinlist")
    img_url_data = Poison.decode!(img_url_fetch.body)
    full_img_data = img_url_data["Data"]

    render(conn, "show.html",
      full_img_data: full_img_data,
      data: data,
      news_data: news_data,
      user_id: id,
    )
  end

end
