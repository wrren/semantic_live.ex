# SemanticLive

Phoenix LiveView component collection that mimics the behaviour of [Semantic-UI](https://semantic-ui.com) components. Under normal circumstances, certain Semantic-UI components need Javascript to operate correctly (Dropdown, Search, etc.). There are also convenient patterns such as Flash messages that are styled differently in Semantic that we'd like to add auto-hiding behaviour to.

This component collection allows dynamic Semantic UI components to be used without relying on Semantic UI's Javascript or jQuery.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `semantic_live` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:semantic_live, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/semantic_live](https://hexdocs.pm/semantic_live).

## Usage

### Dropdown

This will render a dropdown that will display the given set of options. When an option is selected, a hidden input with the
given `name` will have its value set to that of the selected option, making it easy to use this component as part of a form.

```elixir
<%= live_render SemanticLive.Dropdown, session: %{
  form:     f,
  options:  [{"Option A", 1}, {"Option B", 2}],
  name:     :input_name
} %>
```

Or, if importing `SemanticLive`, use the `dropdown` function:

```elixir
<%= dropdown f, :input_name, [{"Option A", 1}, {"Option B", 2}], @socket %>
```

### Search

This will render a search box that will retrieve results using the given function. The function must take a query string and
return a list of results in the form `{name, value}`. This component also sets the value of a hidden input to that of any
result selected so that it can easily be used in a form.

```elixir
<%= live_render SemanticLive.Search, session: %{
  form:     f,
  search:   fn query -> Enum.filter([{"Option A", 1}, {"Option B", 2}], fn{name, _value} -> String.contains(name, query) end),
  name:     :input_name
} %>
```

Or, if importing `SemanticLive`, use the `search` function:

```elixir
<%= search f, :input_name, fn query -> Enum.filter([{"Option A", 1}, {"Option B", 2}], fn{name, _value} -> String.contains(name, query) end), @socket %>
```

### Flash

This component simply displays any flash messages assigned to the current `conn` and then hides itself after a certain length of 
time, 3 seconds by default. Flash messages are displayed in a Semantic UI `message` block.

```elixir
<%= live_render SemanticLive.Flash, session: %{
  conn: @conn
} %>
```

Or, if importing `SemanticLive`, use the `flash` function:

```elixir
<%= flash @conn, :info %>
```