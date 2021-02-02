defmodule Mini.Tracker.Tasks.Query do
  @moduledoc """
  Documentation for Mini.Tracker.Tasks.Query
  """
  import Ecto.Query
  alias Mini.Tracker.Tasks.Task
  alias Mini.Repo

  @limit 10

  @spec list_tasks(tuple()) :: [Task.t()] | []
  def list_tasks(point) do
    coords = Task.points_to_geo_points(point)

    q =
      from(t in Task,
        where: t.status == "new",
        order_by: fragment("start_point <-> ?", ^coords),
        limit: @limit,
        select: [:id, :description]
      )

    Repo.all(q)
  end

  @spec get!(Task.id()) :: Task.t() | no_return
  def get!(id) do
    Task
    |> where(id: ^id)
    |> Repo.one!()
  end

  @spec create(Keyword.t()) :: {:ok, Task.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @spec update(Task.t(), Keyword.t()) :: {:ok, Task.t()} | {:error, Ecto.Changeset.t()}
  def update(task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end
end
