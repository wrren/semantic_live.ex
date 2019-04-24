defmodule SemanticLive.MixProject do
  use Mix.Project

  def project do
    [
      app:              :semantic_live,
      version:          "0.1.0",
      elixir:           "~> 1.8",
      start_permanent:  Mix.env() == :prod,
      licenses:         licenses(),
      links:            links(),
      description:      description(),
      deps:             deps()
    ]
  end

  def licenses do
    [
      "MIT"
    ]
  end

  def links do
    [
      {"GitHub Repository", "https://github.com/wrren/semantic_live.ex"}
    ]
  end

  def description do
    """
    Phoenix LiveView component library that provides Semantic UI components. Phoenix LiveView tends to interfere with
    Semantic's JS initialization, this library allows those components to be used without Javascript while also
    providing convenient functions for including components in templates.
    """
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
      {:phoenix_html, "~> 2.13"},
      {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"}
    ]
  end
end
