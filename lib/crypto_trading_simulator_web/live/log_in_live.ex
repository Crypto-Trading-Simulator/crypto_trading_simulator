defmodule CryptoTradingSimulatorWeb.LogInLive do
  use CryptoTradingSimulatorWeb, :live_view
  alias CryptoTradingSimulator.{Repo, User}
  require Logger

  def mount(_params, _session, socket) do
    {:ok, assign(socket, errormessage: "", form: to_form(%{}))}
  end

  def render(assigns) do
    ~H"""

    <.form for={@form} phx-submit="log_in" >
        <h3>Name</h3>
        <.input type="text" field={@form[:name]} />
        <h3>Email</h3>
        <.input type="email" field={@form[:email]} />
        <.button type="submit">log_in</.button>
        <.button phx-click="sign_up_page">Don't have an account?</.button>
        <%= @errormessage %>
    </.form>

    """
  end


  def handle_event("log_in", %{"email" => email, "name" => name}, socket) do
  exists = Repo.get_by(User, [name: name, email: email])
  IO.inspect(exists.id)
    if exists do
      {:noreply, push_navigate(socket, to: "/#{exists.id}")}
    else
      {:noreply, assign(socket, error_message: "no such user exists")}
    end
  end


  def handle_event("sign_up_page", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/signup")}
  end
end