defmodule CryptoTradingSimulatorWeb.SignUpLive do
  use CryptoTradingSimulatorWeb, :live_view
  alias CryptoTradingSimulator.{Repo, User}
  require Logger

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}))}
  end

  def render(assigns) do
    ~H"""

    <.form for={@form} phx-submit="sign_up" >
        <h3>Name</h3>
        <.input type="text" field={@form[:name]} />
        <h3>Email</h3>
        <.input type="email" field={@form[:email]} />
        <.button phx-click="login_page">Already have an account?</.button>
        <.button type="submit">sign_up</.button>
    </.form>

    """
  end




  # def handle_event("login", %{"email" => "", "name" => ""}, socket) do
  #   IO.inspect("LOOK HERE!", params.email, params.name)
  #   # IO.puts("Email: #{email}, Name: #{name}")
  #   {:noreply, socket}
  # end

  def handle_event("sign_up", %{"email" => email, "name" => name}, socket) do
    Repo.insert(%User{name: name, email: email})
    {:noreply, socket}
  end

  def handle_event("login_page", _params, socket) do
    {:noreply, socket}
  end
end
