defmodule SemanticLive do
  defmacro __using__(_) do
    quote do
      use Phoenix.LiveView
    end
  end
end
