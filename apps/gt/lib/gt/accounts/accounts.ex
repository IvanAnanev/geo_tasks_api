defmodule Gt.Accounts do
  @moduledoc """
  Accounts context.
  """
  alias Gt.Accounts.User

  defmodule Behaviour do
    @moduledoc false
    @callback create_user(attrs :: map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
    @callback find_user_by_email(email :: binary()) :: {:ok, User.t()} | {:error, :not_found}
    @callback verify_user(user :: User.t(), password :: binary()) ::
                {:ok, User.t()} | {:error, binary()}
    @callback authorize(action :: atom(), user :: User.t()) :: :ok | {:error, :forbidden}
    @callback authorize(
                action :: atom(),
                user :: User.t(),
                geo_task :: Gt.GeoTasks.GeoTask.t()
              ) :: :ok | {:error, :forbidden}
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

  @impl true
  def verify_user(%User{} = user, password), do: Bcrypt.check_pass(user, password)

  @impl true
  defdelegate authorize(action, user, geo_task \\ nil), to: Gt.Accounts.Policy
end
