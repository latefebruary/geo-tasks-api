defmodule Mini.Tracker.Tasks.Query do
  @moduledoc """
  Documentation for Mini.Tracker.Tasks.Query
  """
  import Ecto.Query
  alias Mini.Tracker.Tasks.Task
  alias Mini.Repo

  @spec list_tasks(tuple()) :: [Task.t] | []
  def list_tasks({lon, lat}) do
    Repo.all(Task)
  end

  @spec get!(Task.id) :: Task.t | no_return
  def get!(id) do
    Task
    |> where(id: ^id)
    |> Repo.one!()
  end

  @spec create(Keyword.t) :: {:ok, Task.t} | {:error, Ecto.Changeset.t}
  def create(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @spec update(Task.t, Keyword.t) :: {:ok, Task.t} | {:error, Ecto.Changeset.t}
  def update(task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end
end
