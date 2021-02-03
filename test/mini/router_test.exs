defmodule Mini.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias Mini.{Repo, Router}
  alias Mini.Tracker.Tasks.Task
  alias Mini.Tracker.Tokens.Token

  @driver_point [38.716174, -9.141589]
  @start_point [38.716184, -9.141599]
  @end_point [41.157963, -8.629154]
  @description "description"
  @srid 4326

  @opts Router.init([])

  def create_token(role) do
    Repo.insert!(%Token{
      token: Token.random_string(),
      role: role
    })
  end

  describe "GET /tasks" do
    test "for driver returns tasks nearby" do
      Repo.insert!(%Task{
        description: @description,
        start_point: %Geo.Point{coordinates: List.to_tuple(@start_point), srid: @srid},
        end_point: %Geo.Point{coordinates: List.to_tuple(@end_point), srid: @srid},
        status: "new"
      })

      token = create_token("driver")

      conn =
        conn(:get, "/tasks", %{"point" => @driver_point, "token" => token.token})
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 200
      [a_task | _] = Poison.decode!(conn.resp_body)
      assert %{"id" => _, "description" => _} = a_task
    end

    test "returns error when token is not valid" do
      conn =
        conn(:get, "/tasks", %{"point" => @driver_point, "token" => ""})
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 401
      result = Poison.decode!(conn.resp_body)
      assert result == %{"error" => "authentication_failed"}
    end
  end

  describe "POST /tasks" do
    test "manager can create a task" do
      token = create_token("manager")

      params = %{
        "task" => %{
          "start_point" => @start_point,
          "end_point" => @end_point,
          "description" => @description,
          "status" => "new"
        },
        "token" => token.token
      }

      conn =
        conn(:post, "/tasks", params)
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 201
      assert conn.resp_body =~ "Success"
    end

    test "driver can't create a task" do
      token = create_token("driver")

      params = %{
        "task" => %{
          "start_point" => @start_point,
          "end_point" => @end_point,
          "description" => @description,
          "status" => "new"
        },
        "token" => token.token
      }

      conn =
        conn(:post, "/tasks", params)
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 401
      result = Poison.decode!(conn.resp_body)
      assert result == %{"error" => "authentication_failed"}
    end
  end

  describe "PATCH /tasks" do
    test "driver can update a task with status assigned" do
      task =
        Repo.insert!(%Task{
          description: @description,
          start_point: %Geo.Point{coordinates: List.to_tuple(@start_point), srid: @srid},
          end_point: %Geo.Point{coordinates: List.to_tuple(@end_point), srid: @srid},
          status: "new"
        })

      token = create_token("driver")

      params = %{"task" => %{"id" => task.id, "status" => "assigned"}, "token" => token.token}

      conn =
        conn(:patch, "/tasks", params)
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 201
      assert conn.resp_body =~ "Success"
    end

    test "updates a task with status done" do
      task =
        Repo.insert!(%Task{
          description: @description,
          start_point: %Geo.Point{coordinates: List.to_tuple(@start_point), srid: @srid},
          end_point: %Geo.Point{coordinates: List.to_tuple(@end_point), srid: @srid},
          status: "new"
        })

      token = create_token("driver")
      params = %{"task" => %{"id" => task.id, "status" => "done"}, "token" => token.token}

      conn =
        conn(:patch, "/tasks", params)
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 201
      assert conn.resp_body =~ "Success"
    end

    test "error when task not found" do
      token = create_token("driver")
      params = %{"task" => %{"id" => 999_999, "status" => "done"}, "token" => token.token}

      conn =
        conn(:patch, "/tasks", params)
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 404
      result = Poison.decode!(conn.resp_body)
      assert result == %{"error" => "resource_not_found"}
    end

    test "manager can't change status" do
      task =
        Repo.insert!(%Task{
          description: @description,
          start_point: %Geo.Point{coordinates: List.to_tuple(@start_point), srid: @srid},
          end_point: %Geo.Point{coordinates: List.to_tuple(@end_point), srid: @srid},
          status: "new"
        })

      token = create_token("manager")
      params = %{"task" => %{"id" => task.id, "status" => "done"}, "token" => token.token}

      conn =
        conn(:patch, "/tasks", params)
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 401
      result = Poison.decode!(conn.resp_body)
      assert result == %{"error" => "authentication_failed"}
    end
  end

  test "returns 200" do
    conn =
      conn(:get, "/", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end
end
