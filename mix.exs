defmodule Mini.MixProject do
  use Mix.Project

  def project do
    [
      app: :mini,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Mini.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 4.0"},
      {:plug, "~> 1.11"},
      {:cowboy, "~> 2.8"},
      {:plug_cowboy, "~> 2.4"}
    ]
  end
end
