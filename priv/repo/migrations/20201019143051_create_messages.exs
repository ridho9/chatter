defmodule Chatter.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :message, :string
      add :room, :string

      timestamps()
    end

  end
end
