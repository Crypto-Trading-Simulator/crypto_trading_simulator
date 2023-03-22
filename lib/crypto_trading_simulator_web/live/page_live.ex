defmodule CryptoTradingSimulatorWeb.PageLive do
  use CryptoTradingSimulatorWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, number: 7)}
  end

  def render(assigns) do
    ~H"""
    <%= @number %>
    <.button phx-click="add">Add</.button>
    <.button phx-click="subract">Subtract</.button>
    """
  end

  def handle_event("add", _params, socket) do
    {:noreply, assign(socket, number: socket.assigns.number + 1)}
  end

  def handle_event("subract", _params, socket) do
    {:noreply, assign(socket, number: socket.assigns.number - 1)}
  end

end
