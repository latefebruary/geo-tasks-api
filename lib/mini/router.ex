defmodule Mini.Router do
  use Plug.Router
  alias Mini.Tracker.Controllers

  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(message()))
  end

  defp message do
    %{
      api_version: "1.0.0",
      text: "This is an geo-based bug tracker api"
    }
  end

  get "/tasks" do
    body = Controllers.TaskController.index(conn)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, body)
  end

  post "/tasks" do
    body = Controllers.TaskController.create(conn)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, body)
  end

  patch "/tasks" do
    body = Controllers.TaskController.update(conn)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, body)
  end
end
