defmodule CryptoTradingSimulatorWeb.BuyLive do
  use CryptoTradingSimulatorWeb, :live_view
  alias CryptoTradingSimulator.{Repo, User, Crypto}
  require Logger

  def mount(%{"id" => id, "symbol" => symbol}, _session, socket) do
    {:ok, assign(socket, id: id, symbol: symbol, error_message: "", form: to_form(%{}))}
  end

  def render(assigns) do
    ~H"""
    <.button phx-click="back">Back</.button>
    <%= @symbol %>
    <.form for={@form} phx-submit="buy" >
        <h3>Amount in GBP</h3>
        <.input type="number" field={@form[:amount]} />
        <.button type="submit">Buy</.button>
        <.button phx-click="sell_page">Sell Page</.button>
        <%= @error_message %>
    </.form>

    """
  end

  def string_to_number(string) do
    case Integer.parse(string) do
      {int, ""} -> int/1.0
      _ ->
        case Float.parse(string) do
          {float, ""} -> float
          _ -> 0.0
        end
    end
  end

  def handle_event("buy", %{"amount" => amount}, socket) do
    number_amount = string_to_number(amount)
    crypto_symbol = socket.assigns.symbol
    user_id = socket.assigns.id
    number_user_id = trunc(string_to_number(user_id))

    response = HTTPoison.get!("https://min-api.cryptocompare.com/data/price?fsym=#{crypto_symbol}&tsyms=GBP")
    crypto_price = elem(Enum.at(Poison.decode!(response.body), 0), 1)
    user = Repo.get(User, user_id) |> Repo.preload(:cryptos)
    user_coins = user.cryptos |> Enum.map(&(&1.symbol))
    exists = Enum.any?(user_coins, fn coin_symbol -> coin_symbol == crypto_symbol end)

    if exists do
      temp = user.cryptos |> Enum.filter(&(&1.symbol == crypto_symbol))
      temp_2 = temp |> Enum.at(0)
      changeset = Crypto.changeset(temp_2, %{invested: temp_2.invested + number_amount ,amount: temp_2.amount + (number_amount / crypto_price)})
      Repo.update(changeset)
      {:noreply, assign(socket, error_message: "Successfully Bought")}
    else
      coin_info = HTTPoison.get!("https://min-api.cryptocompare.com/data/coin/generalinfo?fsyms=#{crypto_symbol}&tsym=GBP")
      coin_info_decoded = Poison.decode!(coin_info.body)
      coin_fullname = Enum.at(coin_info_decoded["Data"], 0)["CoinInfo"]["FullName"]
      Repo.insert!(
        %Crypto{
          coin: coin_fullname,
          amount: (number_amount / crypto_price),
          invested: number_amount,
          symbol: crypto_symbol,
          user_id: number_user_id
        }
      )
      {:noreply, assign(socket, error_message: "Successfully Bought")}
    end
    {:noreply, push_navigate(socket, to: ~s"/portfolio/#{socket.assigns.id}/")}
  end

  def handle_event("sell_page", _params, socket) do
    {:noreply, push_navigate(socket, to: ~s"/sell/#{socket.assigns.id}/#{socket.assigns.symbol}")}
  end

  def handle_event("back", _params, socket) do
    {:noreply, push_navigate(socket, to: ~s"/home/#{socket.assigns.id}/coinview/#{socket.assigns.symbol}")}
  end
end
