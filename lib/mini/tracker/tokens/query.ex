defmodule Mini.Tracker.Tokens.Query do
  @moduledoc """
  Documentation for Mini.Tracker.Tokens.Query
  """
  import Ecto.Query
  alias Mini.Tracker.Tokens.Token
  alias Mini.Repo

  @spec find(binary()) :: Token.t() | nil
  def find(token) do
    Token
    |> where(token: ^token)
    |> Repo.one()
  end

  @spec create(Keyword.t()) :: {:ok, Token.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end
end
