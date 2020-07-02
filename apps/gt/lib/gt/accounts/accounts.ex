defmodule Gt.Accounts do
  @moduledoc """
  Accounts context.
  """
  alias Gt.Accounts.User

  defmodule Behaviour do
    @moduledoc false
    @callback create_user(attrs :: map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
    @callback find_user_by_email(email :: binary()) :: {:ok, User.t()} | {:error, :not_found}
  end

  @behaviour Gt.Accounts.Behaviour

  @impl true
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Gt.Repo.insert()
  end

  @impl true
  def find_user_by_email(email) do
    case Gt.Repo.get_by(User, email: email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
