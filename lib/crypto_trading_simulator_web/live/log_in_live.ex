defmodule CryptoTradingSimulatorWeb.LogInLive do
  use CryptoTradingSimulatorWeb, :live_view
  alias CryptoTradingSimulator.{Repo, User}
  require Logger

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}))}
  end

  def render(assigns) do
    ~H"""

    <.form for={@form} phx-submit="log_in" >
        <h3>Name</h3>
        <.input type="text" field={@form[:name]} />
        <h3>Email</h3>
        <.input type="email" field={@form[:email]} />
        <.button phx-click="sign_up_page">Don't have an account?</.button>
        <.button type="submit">log_in</.button>
    </.form>

    """
  end


  # def handle_event("login", %{"email" => "", "name" => ""}, socket) do
  #   IO.inspect("LOOK HERE!", params.email, params.name)
  #   # IO.puts("Email: #{email}, Name: #{name}")
  #   {:noreply, socket}
  # end

  def handle_event("log_in", %{"email" => email, "name" => name}, socket) do
    # user = Repo.one!(from u in User, where: u.name == ^name and u.email == ^email)
    Repo.get_by(email: email ) |> Logger.info(Repo.exists?())


    {:noreply, socket}
  end

  def handle_event("sign_up_page", _params, socket) do
    {:noreply, socket}
  end
end
