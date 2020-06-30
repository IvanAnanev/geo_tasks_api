defmodule Gt.AccountsTest do
  use Gt.DataCase, async: true

  alias Gt.Accounts

  describe "create_user/1" do
    test "with unvalid attrs" do
      result = Accounts.create_user(%{})
      assert match?({:error, %Ecto.Changeset{}}, result)
    end

    test "with valid attrs" do
      attrs = %{
        "email" => "some@email.com",
        "role" => "driver",
        "password" => "password"
      }

      result = Accounts.create_user(attrs)
      assert match?({:ok, %Gt.Accounts.User{}}, result)
    end

    test "with already taken email attrs" do
      insert(:user, email: "some@email.com")

      attrs = %{
        "email" => "some@email.com",
        "role" => "driver",
        "password" => "password"
      }

      result = Accounts.create_user(attrs)
      assert match?({:error, %Ecto.Changeset{}}, result)
    end
  end
end
