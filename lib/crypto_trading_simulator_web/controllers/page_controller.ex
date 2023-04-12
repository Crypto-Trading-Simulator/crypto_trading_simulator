defmodule CryptoTradingSimulatorWeb.PageController do
  use CryptoTradingSimulatorWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: "/signup")
  end
end
