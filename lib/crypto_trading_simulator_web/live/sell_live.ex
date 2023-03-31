defmodule CryptoTradingSimulatorWeb.SellLive do
  use CryptoTradingSimulatorWeb, :live_view
  alias CryptoTradingSimulator.{Repo, User, Crypto}
  require Logger

  def mount(%{"id" => id, "symbol" => symbol}, _session, socket) do
    response = HTTPoison.get!("https://min-api.cryptocompare.com/data/price?fsym=#{symbol}&tsyms=GBP")
    crypto_price = elem(Enum.at(Poison.decode!(response.body), 0), 1)

    wallet = case Repo.get_by(Crypto, [user_id: id, symbol: symbol]) do
      nil -> 0.00
      result -> result.amount
    end

    pound_wallet = case Repo.get_by(Crypto, [user_id: id, symbol: "GBP"]) do
      nil -> 0.00
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
    <div class="flex items-start justify-center space-x-5">
      <.button  class="
      bg-blue-500
      hover:bg-blue-700
      text-white font-bold
      py-2 px-4
      rounded-full"
      phx-click="back">Back </.button>

      <.form class="flex flex-col space-y-5 my-9" for={@form} phx-submit="sell" >
        <div>
          <h2> Wallet: </h2>
            <p> <%= "#{:erlang.float_to_binary(@wallet, [decimals: 8])} #{@symbol} (#{:erlang.float_to_binary((@wallet * @crypto_price), [decimals: 2])} GBP)" %> </p>
            <p> <%= " £#{:erlang.float_to_binary(@pound_wallet, [decimals: 2])}" %> </p>
        </div>
        <div>
          <h2> Conversion Rate: </h2>
            <p><%= "1 #{@symbol} = #{@crypto_price} GBP" %></p>
        </div>
        <div class="flex flex-col">
          <h3>Enter Amount to Sell in GBP</h3>
            <.input style="margin: 0 0 2% 0;" type="text" field={@form[:amount]} />
            <.button style="margin: 2%;" class="bg-blue-500
            hover:bg-blue-700 text-white
            font-bold py-2 px-4
              rounded-full"type="submit"
              >Sell</.button>


            <.button style="margin:2%;" phx-click="buy_page"
            class="bg-gray-400
            hover:bg-gray-600
              text-white font-bold
              py-2 px-4
              rounded-full mr-2"
            >Buy Page</.button>
            <p class="flex justify-center text-red-700" ><%= @error_message %></p>
        </div>
      </.form>
    </div>
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
