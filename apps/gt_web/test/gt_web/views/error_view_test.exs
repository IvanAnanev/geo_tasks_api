defmodule GtWeb.ErrorViewTest do
  use GtWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(GtWeb.ErrorView, "404.json", []) == %{errors: %{general: "Not Found"}}
  end

  test "renders 500.json" do
    assert render(GtWeb.ErrorView, "500.json", []) ==
             %{errors: %{general: "Internal Server Error"}}
  end
end
