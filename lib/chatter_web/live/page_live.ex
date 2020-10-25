defmodule ChatterWeb.PageLive do
  use ChatterWeb, :live_view
  alias Chatter.Chatroom.Message

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Message.subscribe()
    end

    message_list = Message.get_latest(100, "default")

    socket =
      socket
      |> assign(message_list: message_list)
      |> assign(message: %Message{})
      |> assign(changeset: Message.changeset(%Message{}, %{}))

    {:ok, socket}
  end

  @impl true
  def handle_info({:message_created, message}, socket) do
    message_list = [message | socket.assigns.message_list]

    socket = assign(socket, message_list: message_list)

    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", %{"message" => message_params}, socket) do
    Message.create(message_params)

    socket =
      socket
      |> assign(message: %Message{})
      |> assign(changeset: Message.changeset(%Message{}, %{}))

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"message" => message_params}, socket) do
    cs =
      socket.assigns.message
      |> Message.changeset(message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: cs)}
  end
end
