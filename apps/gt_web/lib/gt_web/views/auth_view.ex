defmodule GtWeb.AuthView do
  use GtWeb, :view

  def render("tokens.json", %{
        tokens:
          {{access_token, access_token_expires_at}, {refresh_token, refresh_token_expires_at}}
      }) do
    %{
      data: %{
        access_token: %{
          token: access_token,
          expires_at: DateTime.from_unix!(access_token_expires_at)
        },
        refresh_token: %{
          token: refresh_token,
          expires_at: DateTime.from_unix!(refresh_token_expires_at)
        }
      }
    }
  end
end
