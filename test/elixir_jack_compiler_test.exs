defmodule ElixirJackCompilerTest do
  use ExUnit.Case
  doctest ElixirJackCompiler

  test "greets the world" do
    assert ElixirJackCompiler.hello() == :world
  end
end
