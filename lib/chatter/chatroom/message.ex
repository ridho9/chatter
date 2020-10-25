defmodule Chatter.Chatroom.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Chatter.Chatroom.Message
  alias Chatter.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :message, :string
    field :room, :string, default: "default"

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message, :room])
    |> validate_required([:message, :room])
    |> validate_length(:message, min: 1, max: 160)
    |> validate_length(:room, min: 4, max: 10)
  end

  def create(attrs \\ %{}) do
    %Message{}
    |> changeset(attrs)
    |> Repo.insert()
    |> broadcast(:message_created)
  end

  def get_latest(count, room) do
    Repo.all(
      from m in Message,
        limit: ^count,
        where: m.room == ^room,
        order_by: [desc: m.inserted_at],
        select: m
    )
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Chatter.PubSub, "messages")
  end

  defp broadcast({:error, _} = error, _event), do: error

  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(Chatter.PubSub, "messages", {event, post})
    {:ok, post}
  end
end
