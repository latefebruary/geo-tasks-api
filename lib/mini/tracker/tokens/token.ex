defmodule Mini.Tracker.Tokens.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field(:token, :string)
    field(:role, :string)
  end

  @required_fields [:role, :token]
  @roles [:driver, :manager]

  @spec changeset(Token.t(), map) :: Ecto.Changeset.t()
  def changeset(token, params \\ %{}) do
    token
    |> cast(params, @required_fields)
    |> validate_inclusion(:role, @roles)
    |> validate_required(@required_fields)
  end

  @length 16
  @spec random_string() :: binary()
  def random_string do
    :crypto.strong_rand_bytes(@length) |> Base.url_encode64() |> binary_part(0, @length)
  end
end
