defmodule CryptoTradingSimulator.Repo do
  use Ecto.Repo,
    otp_app: :crypto_trading_simulator,
    adapter: Ecto.Adapters.Postgres
end
