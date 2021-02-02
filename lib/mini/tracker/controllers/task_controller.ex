defmodule Mini.Tracker.Controllers.TaskController do
  @moduledoc """
  Documentation for Mini.Tracker.Controllers.TaskController
  """

  alias Mini.Tracker.Tasks.{Query, Task}

  def index(%{"point" => point}) do
    point
    |> Query.list_tasks()
    |> clean_structs()
    |> Poison.encode!()
  end

  defp clean_structs(list) do
    Enum.map(list, fn task ->
      Map.drop(task, [:__meta__, :status, :start_point, :end_point])
      |> Map.delete(:__struct__)
    end)
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
