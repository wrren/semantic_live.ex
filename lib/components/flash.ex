defmodule SemanticLive.Flash do
  use Phoenix.LiveView
  import Phoenix.Controller, only: [get_flash: 2]

  @default_show_for 3_000

  def mount(%{conn: conn} = session, socket) do
    start_timer(session[:show_for])
    {:ok, assign(socket, %{
      show:   true,
      level:  session[:level] || :info,
      conn:   conn,
      class:  message_class(session[:level] || :info)
    })}
  end

  def render(assigns) do
    ~L"""
    <%= if @show == true and get_flash(@conn, @level) != nil do %>
      <div class="ui <%= @class %> message">
        <p><%= get_flash(@conn, @level) %></p>
      </div>
    <% end %>
    """
  end

  def handle_info(:hide, socket),
    do: {:noreply, assign(socket, :show, false)}

  def start_timer(show_for) when is_integer(show_for) and show_for > 0,
    do: Process.send_after(self(), :hide, show_for, [])
  def start_timer(_),
    do: start_timer(@default_show_for)

  @doc """
  Determine the CSS class that should be applied to a flash block based on
  the message level
  """
  def message_class(:info),
    do: "info"
  def message_class(:error),
    do: "negative"
  def message_class(_),
    do: ""
end
