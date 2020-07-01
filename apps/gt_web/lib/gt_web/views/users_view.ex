defmodule GtWeb.UsersView do
  use GtWeb, :view

  def render("user.json", %{user: user}) do
    %{
      data: %{
        email: user.email,
        role: user.role
      }
    }
  end
end
