defmodule Mini.Tracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field(:description, :string)
    field(:start_point, Geo.PostGIS.Geometry)
    field(:end_point, Geo.PostGIS.Geometry)
    field(:status, :string)
  end

  @statuses ~w(
    new
    assigned
    done
  )
  @required_fields ~w(
    description
    start_point
    end_point
    status
  )a
  @srid 4326

  @spec changeset(Task.t(), map) :: Ecto.Changeset.t()
  def changeset(task, params \\ %{}) do
    params = convert_geo_params(params)

    task
    |> cast(params, @required_fields)
    |> prepare_changes(&set_status/1)
    |> validate_inclusion(:status, @statuses)
    |> validate_required(@required_fields)
  end

  defp set_status(changeset) do
    unless get_change(changeset, :status) do
      changeset = %{changeset | status: "new"}
    end

    changeset
  end

  defp convert_geo_params(%{"start_point" => start_point, "end_point" => end_point} = params) do
    %{
      params
      | "start_point" => points_to_geo_points(start_point),
        "end_point" => points_to_geo_points(end_point)
    }
  end

  defp convert_geo_params(params), do: params

  @spec points_to_geo_points(list()) :: Geo.Point.t()
  def points_to_geo_points(point) do
    %Geo.Point{coordinates: List.to_tuple(point), srid: @srid}
  end
end
