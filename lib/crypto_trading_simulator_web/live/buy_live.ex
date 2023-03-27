defmodule CryptoTradingSimulatorWeb.BuyLive do
  use CryptoTradingSimulatorWeb, :live_view
  alias CryptoTradingSimulator.{Repo, User, Crypto}
  require Logger
  use Phoenix.LiveView

  def mount(%{"id" => id, "symbol" => symbol}, _session, socket) do
    {:ok, assign(socket, id: id, symbol: symbol, error_message: "", form: to_form(%{}))}
  end

  def render(assigns) do
    ~H"""
    <%= @symbol %>
    <.form for={@form} phx-submit="buy" >
        <h3>Amount in GBP</h3>
        <.input type="number" field={@form[:amount]} />
        <.button type="submit">Buy</.button>
        <.button phx-click="sell_page">Sell Page</.button>
    </.form>

    """
  end


  def handle_event("buy", %{"amount" => amount}, socket) do
    crypto_symbol = socket.assigns.symbol
    user_id = socket.assigns.id
    Logger.info(socket.assigns)
    response = HTTPoison.get!("https://min-api.cryptocompare.com/data/price?fsym=#{crypto_symbol}&tsyms=GBP")
    price = Poison.decode!(response.body)
    user = Repo.get(User, user_id) |> Repo.preload(:cryptos)
    user_coins = user.cryptos |> Enum.map(&(&1.symbol))
    exists = Enum.any?(user_coins, fn coin_symbol -> coin_symbol == crypto_symbol end)
    if exists do
      temp = user.cryptos |> Enum.filter(&(&1.symbol == crypto_symbol))
      temp_2 = temp |> Enum.at(0)
      IO.inspect(temp_2.amount)
      # changeset = change(%Crypto{amount: temp.amount + amount})
      # Repo.update(changeset)
      # IO.puts(changeset, user.cryptos |> Enum.filter(&(&1.symbol == crypto_symbol)))
    else
    end
    {:noreply, socket}
  end

  def handle_event("sell_page", _params, socket) do
    {:noreply, push_navigate(socket, to: ~s"/sell/#{socket.assigns.id}/#{socket.assigns.symbol}")}
  end
end
