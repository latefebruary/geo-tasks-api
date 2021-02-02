defmodule Mini.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias Mini.{Repo, Router}
  alias Mini.Tracker.Tasks.Task

  @driver_point [38.716174, -9.141589]
  @start_point [38.716184, -9.141599]
  @end_point [41.157963, -8.629154]
  @description "description"
  @srid 4326

  @opts Router.init([])

  test "returns tasks nearby" do
    task =
      Repo.insert!(%Task{
        description: @description,
        start_point: %Geo.Point{coordinates: List.to_tuple(@start_point), srid: @srid},
        end_point: %Geo.Point{coordinates: List.to_tuple(@end_point), srid: @srid},
        status: "new"
      })

    conn =
      conn(:get, "/tasks", %{"point" => @driver_point})
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    [a_task | _] = Poison.decode!(conn.resp_body)
    assert %{"id" => _, "description" => _} = a_task
  end

  test "creates a task" do
    params = %{
      "task" => %{
        "start_point" => @start_point,
        "end_point" => @end_point,
        "description" => @description,
        "status" => "new"
      }
    }

    conn =
      conn(:post, "/tasks", params)
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body =~ "Success"
  end

  test "updates a task with status assigned" do
    task =
      Repo.insert!(%Task{
        description: @description,
        start_point: %Geo.Point{coordinates: List.to_tuple(@start_point), srid: @srid},
        end_point: %Geo.Point{coordinates: List.to_tuple(@end_point), srid: @srid},
        status: "new"
      })

    params = %{"task" => %{"id" => task.id, "status" => "assigned"}}

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

    params = %{"task" => %{"id" => task.id, "status" => "done"}}

    conn =
      conn(:patch, "/tasks", params)
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body =~ "Success"
  end

  test "returns 200" do
    conn =
      conn(:get, "/", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end
end
