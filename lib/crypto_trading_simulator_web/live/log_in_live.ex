defmodule CryptoTradingSimulatorWeb.LogInLive do
  use CryptoTradingSimulatorWeb, :live_view
  alias CryptoTradingSimulator.{Repo, User}
  require Logger

  def mount(_params, _session, socket) do
    {:ok, assign(socket, error_message: "", form: to_form(%{}))}
  end

  def render(assigns) do
    ~H"""

      <div class="flex justify-center" style="margin: 20%;" >
          <.form for={@form} phx-submit="log_in" >
              <h1 class="text-5xl mb-20">Log in & start Trading!</h1>

              <h3>Name</h3>
                <.input type="text" field={@form[:name]} />
              <h3>Email</h3>
                <.input type="email" field={@form[:email]} />
              <div class="flex items-center">
                <.button style="margin: 2%;" class="bg-blue-500
                hover:bg-blue-700 text-white
                font-bold py-2 px-4
                  rounded-full" type="submit">Log In</.button>

                <.button
                class="bg-gray-400
                hover:bg-gray-600
                  text-white font-bold
                  py-2 px-4
                  rounded-full mr-2" style="margin: 2%;" phx-click="sign_up_page">Don't have an account?</.button>
                  <p class="text-red-500"><%= @error_message %></p>
              </div>
          </.form>
      </div>
    """
  end


  def handle_event("log_in", %{"email" => email, "name" => name}, socket) do
  exists = Repo.get_by(User, [name: name, email: email])
    if !(name == "") do
      if exists do
        {:noreply, push_navigate(socket, to: "/home/#{exists.id}")}
      else
        {:noreply, assign(socket, error_message: "no such user exists")}
      end
    else
      {:noreply, assign(socket, error_message: "Enter Fields")}
    end
  end


  def handle_event("sign_up_page", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/signup")}
  end
end
