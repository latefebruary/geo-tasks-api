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
    {status, body} = TaskController.index(conn.params)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end

  post "/tasks" do
    {status, body} = TaskController.create(conn.params)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end

  patch "/tasks" do
    {status, body} = TaskController.update(conn.params)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end
end
