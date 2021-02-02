defmodule Mini.Tracker.Controllers.TaskController do
  @moduledoc """
  Documentation for Mini.Tracker.Controllers.TaskController
  """

  alias Mini.Tracker.Tasks.{Query, Task}

  def index(%{"lat" => lat, "lon" => lon}) do
    Query.list_tasks({lon, lat})
    |> Poison.encode!()
  end

  def create(%{"task" => task_attrs}) do
    {:ok, item} = Query.create(task_attrs)
    Poison.encode!("Success")
  end

  def update(%{"task" => %{"id" => id} = task_attrs}) do
    task = Query.get!(id)
    {:ok, item} = Query.update(task, task_attrs)
    Poison.encode!("Success")
  end
end
