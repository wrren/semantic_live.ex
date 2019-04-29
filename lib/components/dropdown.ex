defmodule SemanticLive.Dropdown do
  use Phoenix.LiveView
  alias Phoenix.HTML.Form

  def mount(%{options: options, name: name, form: form} = session, socket) do
    {:ok, assign(socket, %{
      form:       form,
      options:    options,
      open:       false,
      value:      Form.input_value(form, name),
      tag:        session[:tag],
      name:       Form.input_name(form, name),
      text:       session[:text]  || "Select",
      selection:  find_name(options, Form.input_value(form, name)),
      class:      session[:class] || ""
    })}
  end
  def mount(%{options: options, tag: tag} = session, socket) when length(options) > 0 do
    {:ok, assign(socket, %{
      options:    options,
      tag:        tag,
      open:       false,
      value:      session[:value] || elem(Enum.at(options, 0), 0),
      name:       nil,
      text:       session[:text]  || "Select",
      selection:  find_name(options, session[:value] || elem(Enum.at(options, 0), 0)),
      class:      session[:class] || ""
    })}
  end
  def mount(%{options: options, tag: tag} = session, socket) when length(options) > 0 do
    {:ok, assign(socket, %{
      options:    options,
      tag:        tag,
      open:       false,
      value:      nil,
      name:       nil,
      text:       session[:text]  || "Select",
      selection:  nil,
      class:      session[:class] || ""
    })}
  end

  def render(assigns) do
    ~L"""
    <div    class="ui selection dropdown visible <%= if @open do %>active<% end %> <%= @class %>"
            phx-click="toggle"
    >
      <div class="default text"><%= @selection || @text %></div>
      <i class="dropdown icon" phx-click="toggle"></i>
      <%= if @name != nil do %>
        <input type="hidden" name="<%= @name %>" value="<%= @value %>" />
      <% end %>
      <div class="menu transition <%= if @open do %>visible<% else %>hidden<% end %>" tabindex="-1">
      <%= for {name, value} <- @options do %>
          <div class="item" phx-click="select" phx-value="<%= value %>"><%= name %></div>
      <% end %>
      </div>
    </div>
    """
  end

  def handle_event("select", value, %{assigns: %{options: options, tag: tag}, parent_pid: pid} = socket) when tag != nil and is_pid(pid) do
    send(pid, {:option_selected, tag, {find_name(options, value), find_value(options, value)}})
    {:noreply, assign(socket, %{
      open:       false,
      value:      value,
      selection:  find_name(options, value),
    })}
  end
  def handle_event("select", value, %{assigns: %{options: options}} = socket) do
    {:noreply, assign(socket, %{
      open:       false,
      value:      value,
      selection:  find_name(options, value),
    })}
  end

  def handle_event("toggle", _, %{assigns: %{open: open}} = socket),
    do: {:noreply, assign(socket, :open, not open)}

  #
  # Find the name associated with the given string value
  #
  defp find_name(options, value) when is_list(options) and value != nil,
    do: find_name(options, value, nil)
  defp find_name({name, _}, _default),
    do: name
  defp find_name(default, default),
    do: default
  defp find_name(_options, nil),
    do: nil
  defp find_name(options, value, default) when is_list(options) and is_binary(value) do
    options
    |> find_option(value)
    |> find_name(default)
  end
  defp find_name(options, value, default) when is_list(options) do
    options
    |> Enum.find(default, fn {_, v} -> v == value end)
    |> find_name(default)
  end

  #
  # Find the option value that corresponds to the given value string. Values sent as live view
  # events are always in string form, this function lets us get the value in its original type.
  #
  defp find_value({_name, value}),
    do: value
  defp find_value(options, value) when is_list(options) and is_binary(value) do
    options
    |> find_option(value)
    |> find_value()
  end

  #
  # Find the option that corresponds to the given value
  #
  defp find_option(options, value) when is_list(options) and is_binary(value) do
    options
    |> Enum.find(nil, fn {_, v} ->
      cond do
        is_binary(v)  -> value == v
        is_atom(v)    -> value == Atom.to_string(v)
        is_integer(v) -> value == Integer.to_string(v)
        true          -> false
      end
    end)
  end
end
