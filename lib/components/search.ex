defmodule SemanticLive.Search do
  use Phoenix.LiveView
  alias Phoenix.HTML.Form

  def mount(%{search: fun, name: name, form: form}, socket) do
    socket = socket
    |> assign(:results,   [])
    |> assign(:search,    fun)
    |> assign(:query,     "")
    |> assign(:loading,   false)
    |> assign(:value,     Form.input_value(form, name))
    |> assign(:name,      Form.input_name(form, name))

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="ui <%= if @loading do %>loading<% end %> search">
      <input type="hidden" name="<%= @name %>" value="<%= @value %>" />
      <form phx-change="search" autocomplete="off">
          <div class="ui right action left icon input">
              <i class="search icon"></i>
              <input
                  class="prompt"
                  type="text"
                  name="query"
                  value="<%= @query %>"
                  placeholder="Search"
              />
          </div>
          <div class="results">
          <%= for {name, _} <- @results do %>
              <a class="result">
                  <div class="content" phx-click="select" phx-value="<%= name %>"><div class="title"><%= name %></div></div>
              </a>
          <% end %>
          </div>
      </form>
    </div>
    """
  end

  def handle_event("search", %{"query" => query}, socket) do
    send(self(), {:search, query})
    {:noreply, assign(socket, loading: true, query: query)}
  end
  def handle_event("select", name, %{assigns: %{results: results}} = socket) do
    case Enum.find(results, fn {^name, _} -> true; _ -> false end) do
      nil ->
        {:noreply, assign(socket, results: [], query: "")}
      {_name, value} ->
        {:noreply, assign(socket, results: [], query: "", value: value)}
    end
  end
  def handle_event("select", _name, %{assigns: %{select: nil}} = socket) do
    {:noreply, assign(socket, results: [], query: "")}
  end
  def handle_info({:search, query}, %{assigns: %{search: search, query: query}} = socket) do
    case search.(query) do
      {:ok, results} ->
        {:noreply, assign(socket, results: results, loading: false)}
      {:error, _reason} ->
        {:noreply, assign(socket, results: [], loading: false)}
    end
  end
end
