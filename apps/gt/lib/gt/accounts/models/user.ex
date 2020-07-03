defmodule Gt.Accounts.User do
  @moduledoc """
  Table users.
  """
  import EctoEnum
  import Ecto.Changeset
  use Ecto.Schema

  defenum(Role, :role, [:manager, :driver])

  @timestamps_opts [type: :utc_datetime]

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :role, Gt.Accounts.User.Role

    field :password, :string, virtual: true

    timestamps()
  end

  @required_fields ~w(email password role)a

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/@/)
    |> validate_enum(:role)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
