defmodule Mini.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add(:token, :string, null: false)
      add(:role, :string, null: false)
    end
  end
end
