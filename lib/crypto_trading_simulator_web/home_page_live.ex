defmodule CryptoTradingSimulatorWeb.HomePageLive do
  use CryptoTradingSimulatorWeb, :live_view
  alias CryptoTradingSimulator.{Repo, User, Crpto}
  require Logger

  def mount(_params, _session, socket) do
    {:ok, assign(socket,  user_id: "")}
  end

  def render(assigns) do
    ~H"""
    <%= @user_id %>
    """
  end
end
