defmodule GtWeb.ErrorView do
  use GtWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render("error.json", %{message: error_message}) when is_binary(error_message) do
    %{errors: %{general: String.capitalize(error_message)}}
  end

  def template_not_found(template, _assigns) do
    %{errors: %{general: Phoenix.Controller.status_message_from_template(template)}}
  end
end
