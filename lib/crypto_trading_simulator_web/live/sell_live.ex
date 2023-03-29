defmodule CryptoTradingSimulatorWeb.SellLive do
  use CryptoTradingSimulatorWeb, :live_view
  alias CryptoTradingSimulator.{Repo, User, Crypto}
  require Logger

  def mount(%{"id" => id, "symbol" => symbol}, _session, socket) do
    response = HTTPoison.get!("https://min-api.cryptocompare.com/data/price?fsym=#{symbol}&tsyms=GBP")
    crypto_price = elem(Enum.at(Poison.decode!(response.body), 0), 1)

    wallet = case Repo.get_by(Crypto, [user_id: id, symbol: symbol]) do
      nil -> 0
      result -> result.amount
    end

    pound_wallet = case Repo.get_by(Crypto, [user_id: id, symbol: "GBP"]) do
      nil -> 0
      result -> result.amount
    end

    {:ok, assign(socket,
        id: id,
        symbol: symbol,
        wallet: wallet,
        pound_wallet: pound_wallet,
        crypto_price: crypto_price,
        error_message: "", form: to_form(%{}))}
  end

  def render(assigns) do
    ~H"""
    <.button phx-click="back">Back</.button>

    <.form for={@form} phx-submit="sell" >
        <%= "Wallet:" %> <br>
        <%= "#{@wallet} #{@symbol} (#{@wallet * @crypto_price} GBP)" %> <br>
        <%= " £#{@pound_wallet}" %> <br>
        <%= "Conversion Rate:" %> <br>
        <%= "1 #{@symbol} = #{@crypto_price} GBP" %>
        <h3>Enter Amount to Sell in GBP</h3>
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

    user = Repo.get(User, user_id) |> Repo.preload(:cryptos)
    current_user_crypto = user.cryptos |> Enum.filter(&(&1.symbol == crypto_symbol)) |> Enum.at(0)
    current_user_pounds = user.cryptos |> Enum.filter(&(&1.symbol == "GBP")) |> Enum.at(0)

    suffient? = current_user_crypto.amount - (number_amount / socket.assigns.crypto_price)
    if number_amount == 0 or not is_number(number_amount)do
      {:noreply, assign(socket, error_message: "Enter a valid number")}
    else
      cond do
        suffient? > 0.0001 ->
          crypto_changeset = Crypto.changeset(current_user_crypto, %{amount: suffient?})
          Repo.update(crypto_changeset)
          pound_changeset = Crypto.changeset(current_user_pounds, %{amount: current_user_pounds.amount + number_amount})
          Repo.update(pound_changeset)

          {:noreply, push_navigate(socket, to: ~s"/portfolio/#{socket.assigns.id}/")}

        suffient? <= 0.000001 and suffient? >= 0 ->
          crypto = Repo.get_by(Crypto, [symbol: crypto_symbol, user_id: user_id])
          Repo.delete!(crypto)
          pound_changeset = Crypto.changeset(current_user_pounds, %{amount: current_user_pounds.amount + number_amount})
          Repo.update(pound_changeset)
          {:noreply, push_navigate(socket, to: ~s"/portfolio/#{socket.assigns.id}/")}

        true ->
          {:noreply, assign(socket, error_message: "Insufficient Funds")}
      end
    end
  end

  def handle_event("buy_page", _params, socket) do
    {:noreply, push_navigate(socket, to: ~s"/buy/#{socket.assigns.id}/#{socket.assigns.symbol}")}
  end

  def handle_event("back", _params, socket) do
    {:noreply, push_navigate(socket, to: ~s"/home/#{socket.assigns.id}/coinview/#{socket.assigns.symbol}")}
  end

end
