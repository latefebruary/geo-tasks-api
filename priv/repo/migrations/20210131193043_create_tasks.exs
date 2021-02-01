defmodule Mini.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add(:description, :string, null: false)
      add(:start_point, :geometry, null: false)
      add(:end_point, :geometry, null: false)
      add(:status, :string, null: false)
    end
  end
end
