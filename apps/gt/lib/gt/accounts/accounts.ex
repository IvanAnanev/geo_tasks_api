defmodule Gt.Accounts do
  @moduledoc """
  Accounts context.
  """
  alias Gt.Accounts.User

  @spec create_user(attrs :: map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Gt.Repo.insert()
  end
end
