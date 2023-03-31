defmodule CryptoTradingSimulatorWeb.BuyLive do
  use CryptoTradingSimulatorWeb, :live_view
  alias ElixirLS.LanguageServer.Experimental.SourceFile.Conversions
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
      crypto_price: crypto_price,
      wallet: wallet,
      pound_wallet: pound_wallet,
      error_message: "",
      form: to_form(%{})

    )}
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

      <.form class="flex flex-col space-y-5 my-9" for={@form} phx-submit="buy" >
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
          <h3>Enter Amount to Buy in GBP</h3>
            <.input style="margin: 0 0 2% 0;" type="text" field={@form[:amount]} />
            <.button style="margin: 2%;" class="bg-blue-500
            hover:bg-blue-700 text-white
            font-bold py-2 px-4
              rounded-full"type="submit"
              >Buy</.button>


            <.button style="margin:2%;" phx-click="sell_page"
            class="bg-gray-400
            hover:bg-gray-600
              text-white font-bold
              py-2 px-4
              rounded-full mr-2"
            >Sell Page</.button>
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

  def handle_event("buy", %{"amount" => amount}, socket) do
    number_amount = string_to_number(amount)
    if number_amount == 0 or not is_number(number_amount)do
      {:noreply, assign(socket, error_message: "Enter a valid number")}
    else
      crypto_symbol = socket.assigns.symbol
      user_id = socket.assigns.id
      number_user_id = trunc(string_to_number(user_id))

      user = Repo.get(User, user_id) |> Repo.preload(:cryptos)
      user_coins = user.cryptos |> Enum.map(&(&1.symbol))
      exists = Enum.any?(user_coins, fn coin_symbol -> coin_symbol == crypto_symbol end)
      current_user_pounds = user.cryptos |> Enum.filter(&(&1.symbol == "GBP")) |> Enum.at(0)

      if current_user_pounds.amount - number_amount >= 0 do
        if exists do
          current_user_cryptos = user.cryptos |> Enum.filter(&(&1.symbol == crypto_symbol)) |> Enum.at(0)
          crypto_changeset = Crypto.changeset(current_user_cryptos, %{amount: current_user_cryptos.amount + (number_amount / socket.assigns.crypto_price)})
          Repo.update(crypto_changeset)
          pound_changeset = Crypto.changeset(current_user_pounds, %{amount: current_user_pounds.amount - number_amount})
          Repo.update(pound_changeset)

          {:noreply, push_navigate(socket, to: ~s"/portfolio/#{socket.assigns.id}/")}
        else
          coin_info = HTTPoison.get!("https://min-api.cryptocompare.com/data/coin/generalinfo?fsyms=#{crypto_symbol}&tsym=GBP")
          coin_info_decoded = Poison.decode!(coin_info.body)
          coin_fullname = Enum.at(coin_info_decoded["Data"], 0)["CoinInfo"]["FullName"]
          Repo.insert!(
            %Crypto{
              coin: coin_fullname,
              amount: (number_amount / socket.assigns.crypto_price),
              symbol: crypto_symbol,
              user_id: number_user_id
            }
          )
          pound_changeset = Crypto.changeset(current_user_pounds, %{amount: current_user_pounds.amount - number_amount})
          Repo.update(pound_changeset)
          {:noreply, push_navigate(socket, to: ~s"/portfolio/#{socket.assigns.id}/")}
        end
      else
        {:noreply, assign(socket, error_message: "Insufficient Funds")}
      end
    end
  end

  def handle_event("sell_page", _params, socket) do
    {:noreply, push_navigate(socket, to: ~s"/sell/#{socket.assigns.id}/#{socket.assigns.symbol}")}
  end

  def handle_event("back", _params, socket) do
    {:noreply, push_navigate(socket, to: ~s"/home/#{socket.assigns.id}/coinview/#{socket.assigns.symbol}")}
  end
end
