defmodule Gt.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute(
      "CREATE TYPE role AS ENUM ('manager', 'driver')",
      "DROP TYPE role"
    )

    execute("CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public", "")

    create table(:users) do
      add :email, :citext, null: false
      add :password_hash, :string, null: false
      add :role, :role, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
