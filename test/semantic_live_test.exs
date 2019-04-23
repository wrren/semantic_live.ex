defmodule SemanticLiveTest do
  use ExUnit.Case
  doctest SemanticLive

  test "greets the world" do
    assert SemanticLive.hello() == :world
  end
end
