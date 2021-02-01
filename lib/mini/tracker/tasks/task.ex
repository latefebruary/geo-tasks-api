defmodule Mini.Tracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task" do
    field(:description, :string)
    field(:start_point, Geo.PostGIS.Geometry)
    field(:end_point, Geo.PostGIS.Geometry)
    field(:status, :string)
  end

  @statuses ~w(
    new
    assigned
    done
  )a

  @spec changeset(Task.t, map) :: Ecto.Changeset.t
  def changeset(task, params \\ %{}) do
    task
    |> cast(params, [:description, :start_point, :end_point, :status])
    |> prepare_changes(&set_status/1)
    |> prepare_changes(&set_coordinates/1)
    |> validate_inclusion(:status, @statuses)
    |> validate_required([:description, :start_point, :end_point, :status])
  end

  def set_status(changeset) do
    unless get_change(changeset, :status) do
      changeset = %{changeset | status: "new"}
    end
    changeset
  end

  def set_coordinates(changeset) do
    if start_point = get_change(changeset, :start_point) do
      start_point = %Geo.Point{ coordinates: List.to_tuple(start_point), srid: 4326}
      end_point = %Geo.Point{ coordinates: List.to_tuple(end_point), srid: 4326}

      changeset = %{changeset | start_point: start_point}
      changeset = %{changeset | end_point: end_point}
    end
    changeset
  end
end
