defmodule Gt.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Gt.Repo

  def user_factory do
    %Gt.Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      password_hash: sequence("pass_hash"),
      role: sequence(:role, [:manager, :driver])
    }
  end
end
