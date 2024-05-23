defmodule Issues.MixProject do
  use Mix.Project

  def project do
    [
      app: :issues,
      escript: escript_config(),
      version: "0.0.1",
      name: "Issues",
      source_url: "https://github.com/brunoferromega/issues",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:httpoison, "~> 2.2.1"},
      {:poison, "~> 5.0.0"},
      {:earmark, "~> 1.4"},
      {:ex_doc, "~> 0.33.0"}
    ]
  end

  defp escript_config do
    [
      main_module: Issues.Cli
    ]
  end
end
