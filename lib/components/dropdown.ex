defmodule SemanticLive.Dropdown do
  use SemanticLive

  def mount(%{options: options, name: name} = session, socket) do
    {:ok, assign(socket, %{
      options:    options,
      open:       false,
      value:      nil,
      name:       name,
      selection:  nil,
      text:       session[:text]  || "Select",
      class:      session[:class] || ""
    })}
  end

  def render(assigns) do
    ~L"""
    <div    class="ui selection dropdown visible <%= if @open do %>active<% end %> <%= @class %>"
            phx-target="window"
            phx-click="toggle"
    >
      <div class="default text"><%= @selection || @text %></div>
      <i class="dropdown icon" phx-click="toggle"></i>
      <input type="hidden" name="<%= @name %>" value="<%= @value %>" />
      <div class="menu transition <%= if @open do %>visible<% else %>hidden<% end %>" tabindex="-1">
      <%= for {name, value} <- @options do %>
          <div class="item" phx-click="select" phx-value="<%= value %>"><%= name %></div>
      <% end %>
      </div>
    </div>
    """
  end

  def handle_event("select", value, %{assigns: %{options: options}} = socket),
    do: {:noreply, assign(socket, %{
      open:       false,
      value:      value,
      selection:  find_name(options, value),
    })}
  def handle_event("toggle", _, %{assigns: %{open: open}} = socket),
    do: {:noreply, assign(socket, :open, not open)}

  #
  # Find the name associated with the given string value
  #
  defp find_name(options, value) when is_list(options),
    do: find_name(options, value, nil)
  defp find_name({name, _}, _default),
    do: name
  defp find_name(default, default),
    do: default
  defp find_name(options, value, default) when is_list(options) and is_binary(value) do
    Enum.find(options, default, fn {_, v} ->
      cond do
        is_binary(v)  -> value == v
        is_atom(v)    -> value == Atom.to_string(v)
        is_integer(v) -> value == Integer.to_string(v)
        true          -> false
      end
    end)
    |> find_name(default)
  end
end
