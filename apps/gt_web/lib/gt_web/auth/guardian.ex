defmodule GtWeb.Guardian do
  @moduledoc false
  use Guardian, otp_app: :gt

  @accounts Application.compile_env(:gt, :accounts_context, Gt.Accounts)

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.email)}
  end

  def resource_from_claims(claims) do
    @accounts.find_user_by_email(claims["sub"])
  end
end
