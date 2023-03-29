defmodule CryptoTradingSimulatorWeb.ResetController do
  use CryptoTradingSimulatorWeb, :controller
  alias CryptoTradingSimulator.{Repo, User, Crypto}
  require Logger
  import Ecto.Query

  def reset(conn, %{"id" => id}) do
    from(c in Crypto, where: c.user_id == ^id)
    |> Repo.delete_all()
    Repo.insert!(%Crypto{coin: "Pounds", symbol: "GBP", amount: 1000.00, user_id: String.to_integer(id)})

    conn
    |> put_flash(:info, "Reset successful")
    |> redirect(to: "/portfolio/#{id}")
  end
end
