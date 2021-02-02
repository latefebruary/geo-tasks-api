defmodule Mini.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias Mini.{Repo, Router}
  alias Mini.Tracker.Tasks.Task

  @lat "-37.65"
  @lon "-21.4833"
  @start_point [-21.4839, -37.6511]
  @end_point [-21.4812, -37.6515]
  @description "description"
  @srid 4326

  @opts Router.init([])

  test "returns tasks nearby" do
    conn =
      conn(:get, "/tasks", %{"lat" => @lat, "lon" => @lon})
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "[]"
  end

  test "creates a task" do
    params = %{"task" => %{"start_point" => @start_point, "end_point" => @end_point, "description" => @description, "status" => "new"}}
    conn =
      conn(:post, "/tasks", params)
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body =~ "Success"
  end

  test "updates a task with status assigned" do
    task = Repo.insert! %Task{
      description: @description,
      start_point: %Geo.Point{ coordinates: List.to_tuple(@start_point), srid: @srid},
      end_point: %Geo.Point{ coordinates: List.to_tuple(@end_point), srid: @srid},
      status: "new",
    }

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
    task = Repo.insert! %Task{
      description: @description,
      start_point: %Geo.Point{ coordinates: List.to_tuple(@start_point), srid: @srid},
      end_point: %Geo.Point{ coordinates: List.to_tuple(@end_point), srid: @srid},
      status: "new",
    }

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
