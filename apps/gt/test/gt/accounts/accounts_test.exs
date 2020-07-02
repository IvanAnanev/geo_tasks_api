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

  describe "find_user_by_email/1" do
    setup do
      insert(:user, email: "some@email.com")
      :ok
    end

    test "user is present" do
      result = Accounts.find_user_by_email("some@email.com")
      assert match?({:ok, %Gt.Accounts.User{email: "some@email.com"}}, result)
    end

    test "user is not present" do
      result = Accounts.find_user_by_email("amother@email.com")
      assert match?({:error, :not_found}, result)
    end

    test "email citext field type" do
      result = Accounts.find_user_by_email("SOME@email.com")
      assert match?({:ok, %Gt.Accounts.User{email: "some@email.com"}}, result)
    end
  end

  describe "verify_user/2" do
    setup do
      user = insert(:user, password_hash: Bcrypt.hash_pwd_salt("password"))
      {:ok, user: user}
    end

    test "success", %{user: user} do
      result = Accounts.verify_user(user, "password")
      assert {:ok, user} == result
    end

    test "fail", %{user: user} do
      result = Accounts.verify_user(user, "wrong_password")
      assert {:error, "invalid password"} == result
    end
  end
end
