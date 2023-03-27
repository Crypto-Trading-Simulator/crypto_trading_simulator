defmodule CryptoTradingSimulatorWeb.SellLive do
  use CryptoTradingSimulatorWeb, :live_view
  alias CryptoTradingSimulator.{Repo, User}
  require Logger

  def mount(%{"id" => id, "symbol" => symbol}, _session, socket) do
    {:ok, assign(socket, id: id, symbol: symbol, error_message: "", form: to_form(%{}))}
  end

  def render(assigns) do
    ~H"""
    <%= @symbol %>
    <.form for={@form} phx-submit="sign_up" >
        <h3>Name</h3>
        <.input type="text" field={@form[:name]} />
        <h3>Email</h3>
        <.input type="email" field={@form[:email]} />
        <.button type="submit">Sell</.button>
        <.button phx-click="buy_page">Buy Page</.button>
    </.form>

    """
  end


  def handle_event("sell", %{"id" => id, "symbol" => symbol, "amount" => _amount}, socket) do
    response = HTTPoison.get!("https://min-api.cryptocompare.com/data/price?fsym=#{symbol}&tsyms=GBP")
    data = Poison.decode!(response.body)
    user = Repo.get(User, id) |> Repo.preload(:cryptos)
    user_coins = user.cryptos |> Enum.map(&(&1.symbol))
    exists = Enum.any?(user_coins, fn coin_symbol -> coin_symbol == symbol end)
    IO.puts(exists)
  end

  def handle_event("buy_page", _params, socket) do
    {:noreply, push_navigate(socket, to: ~s"/buy/#{socket.assigns.id}/#{socket.assigns.symbol}")}
  end

end
