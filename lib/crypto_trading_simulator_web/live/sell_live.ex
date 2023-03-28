defmodule CryptoTradingSimulatorWeb.SellLive do
  use CryptoTradingSimulatorWeb, :live_view
  alias CryptoTradingSimulator.{Repo, User, Crypto}
  require Logger

  def mount(%{"id" => id, "symbol" => symbol}, _session, socket) do
    {:ok, assign(socket, id: id, symbol: symbol, error_message: "", form: to_form(%{}))}
  end

  def render(assigns) do
    ~H"""
    <%= @symbol %>
    <.form for={@form} phx-submit="sell" >
        <h3>Amount in GBP</h3>
        <.input type="text" field={@form[:amount]} />
        <.button type="submit">Sell</.button>
        <.button phx-click="buy_page">Buy Page</.button>
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

  def handle_event("sell", %{"amount" => amount}, socket) do
    number_amount = string_to_number(amount)
    crypto_symbol = socket.assigns.symbol
    user_id = socket.assigns.id
    number_user_id = trunc(string_to_number(user_id))

    response = HTTPoison.get!("https://min-api.cryptocompare.com/data/price?fsym=#{crypto_symbol}&tsyms=GBP")
    crypto_price = elem(Enum.at(Poison.decode!(response.body), 0), 1)
    user = Repo.get(User, user_id) |> Repo.preload(:cryptos)
    current_user_crypto = user.cryptos |> Enum.filter(&(&1.symbol == crypto_symbol)) |> Enum.at(0)

    suffient? = current_user_crypto.amount - (number_amount / crypto_price)
    cond do
      suffient? > 0.0001 ->

        changeset = Crypto.changeset(current_user_crypto, %{invested: current_user_crypto.invested - number_amount ,amount: suffient?})
        Repo.update(changeset)

        {:noreply, assign(socket, error_message: "Successfully Sold")}

      suffient? <= 0.0001 ->
        crypto = Repo.get_by(Crypto, [symbol: crypto_symbol, user_id: user_id])
        Repo.delete!(crypto)
        {:noreply, assign(socket, error_message: "Successfully Sold")}

      true ->
        {:noreply, assign(socket, error_message: "Insufficient Funds")}
    end
  end

  def handle_event("buy_page", _params, socket) do
    {:noreply, push_navigate(socket, to: ~s"/buy/#{socket.assigns.id}/#{socket.assigns.symbol}")}
  end

end
