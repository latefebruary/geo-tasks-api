defmodule Mini.Tracker.Controllers.TaskController do
  @moduledoc """
  Documentation for Mini.Tracker.Controllers.TaskController
  """

  alias Mini.Tracker.Tasks.Query, as: TaskQuery
  alias Mini.Tracker.Tasks.Task
  alias Mini.Tracker.Tokens.{Query, Token}

  def index(%{"point" => point, "token" => token}) do
    with %Token{role: "driver"} <- Query.find(token) do
      items =
        point
        |> TaskQuery.list_tasks()
        |> clean_structs()
        |> Poison.encode!()

      {200, items}
    else
      _ -> {401, Poison.encode!(%{error: :authentication_failed})}
    end
  end

  defp clean_structs(list) do
    Enum.map(list, fn task ->
      Map.drop(task, [:__meta__, :status, :start_point, :end_point])
      |> Map.delete(:__struct__)
    end)
  end

  def create(%{"task" => task_attrs, "token" => token}) do
    with %Token{role: "manager"} <- Query.find(token),
         {:ok, _} <- TaskQuery.create(task_attrs) do
      {201, Poison.encode!("Success")}
    else
      {:error, error} -> {422, Poison.encode!(error)}
      _ -> {401, Poison.encode!(%{error: :authentication_failed})}
    end
  end

  def update(%{"task" => %{"id" => id} = task_attrs, "token" => token}) do
    with %Token{role: "driver"} <- Query.find(token),
         %Task{} = task <- TaskQuery.get(id),
         {:ok, _} <- TaskQuery.update(task, task_attrs) do
      {201, Poison.encode!("Success")}
    else
      nil -> {404, Poison.encode!(%{error: :resource_not_found})}
      {:error, error} -> {422, Poison.encode!(error)}
      _ -> {401, Poison.encode!(%{error: :authentication_failed})}
    end
  end
end
