defmodule Gt.Accounts do
  @moduledoc """
  Accounts context.
  """
  alias Gt.Accounts.User

  defmodule Behaviour do
    @moduledoc false
    @callback create_user(attrs :: map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  end

  @behaviour Gt.Accounts.Behaviour

  @impl true
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Gt.Repo.insert()
  end
end
