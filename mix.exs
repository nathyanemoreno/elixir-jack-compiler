defmodule ElixirJackCompiler.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_jack_compiler,
      name: "elixir-jack-compile",
      version: "1.0.0",
      description: description(),
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript(),
      source_url: "https://github.com/nathyanemoreno/elixir-jack-compiler"
    ]
  end

  defp description() do
    "This project was developed under the exercise of Compilers course from the Federal University of Maranhao"
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def escript do
    [main_module: ElixirJackCompiler.CLI]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
