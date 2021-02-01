defmodule AutoriaCars.MixProject do
  use Mix.Project

  def project do
    [
      app: :autoria_cars,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {AutoriaCars.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:crawly, "~> 0.12.0"},
      {:floki, "~> 0.26.0"},
      {:httpoison, "~> 1.7.0", override: true},
      {:nadia, "~> 0.7.0"}
    ]
  end
end
