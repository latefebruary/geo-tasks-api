defmodule Mini.Router do
  use Plug.Router
  alias Mini.Tracker.Controllers.TaskController

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
    body = TaskController.index(conn.params)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, body)
  end

  post "/tasks" do
    body = TaskController.create(conn.params)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(201, body)
  end

  patch "/tasks" do
    body = TaskController.update(conn.params)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, body)
  end
end
