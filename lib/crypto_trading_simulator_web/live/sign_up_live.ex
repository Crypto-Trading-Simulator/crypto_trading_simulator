defmodule CryptoTradingSimulatorWeb.SignUpLive do
  use CryptoTradingSimulatorWeb, :live_view
  alias CryptoTradingSimulator.{Repo, Crypto, User}
  require Logger

  def mount(_params, _session, socket) do
    {:ok, assign(socket, error_message: "", form: to_form(%{}))}
  end

  def render(assigns) do
    ~H"""

    <.form for={@form} phx-submit="sign_up" >
        <h3>Name</h3>
        <.input type="text" field={@form[:name]} />
        <h3>Email</h3>
        <.input type="email" field={@form[:email]} />
        <.button type="submit">Sign Up</.button>
        <.button phx-click="login_page">Already have an account?</.button>
        <%= @error_message %>
    </.form>

    """
  end

  def handle_event("sign_up", %{"email" => email, "name" => name}, socket) do
    exists = Repo.get_by(User, [name: name, email: email])

    if exists do
      {:noreply, assign(socket, error_message: "User already has an account")}
    else
      changeset = User.changeset(%User{}, %{name: name, email: email})
      case Repo.insert(changeset) do
        {:ok, exists}
          -> user = Repo.get_by(User, [name: name, email: email])
              Repo.insert!(%Crypto{coin: "Pounds", symbol: "GBP", amount: 1000.00, user_id: user.id})
              {:noreply, push_navigate(socket, to: ~p"/home/#{exists.id}")}
        {:error, _changeset} -> {:noreply, assign(socket, error_message: "Invalid Fields")}
      end


    end
  end

  def handle_event("login_page", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/login")}
  end
end
