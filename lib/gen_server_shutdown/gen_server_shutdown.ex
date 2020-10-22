defmodule GenServerShutdown do
  use GenServer

  @impl true
  def init(args) do
    {:ok, args}
  end

  @impl true
  def handle_cast(action, _state) do
    IO.puts(action)
    {:noreply, []}
  end

  @impl true
  def handle_info(func_or_action, _state) do
    if is_function(func_or_action) do
      func_or_action.()
    else
      if func_or_action == 10 do
        IO.puts(func_or_action)
        {:noreply, []}
      else
        func_or_action
      end
    end
  end
end

defmodule GenServerSupervisor do
  def start do
    child = %{
      id: Server,
      start: {GenServerShutdown, []}
    }

    {:ok, pid} = Supervisor.start_link([child], strategy: :one_for_one)
    pid
  end
end

defmodule GenServerCaller do
  def start_link do
    GenServer.start_link(GenServerShutdown, [], name: GSL)
  end

  def start do
    GenServer.start(GenServerShutdown, [], name: GS)
  end

  def send_msg(name, signal \\ 10) do
    m_1 = Enum.to_list(1..9)

    Enum.each(m_1, fn msg ->
      GenServer.cast(name, msg)
    end)

    Process.send(name, signal, [])

    m_2 = Enum.to_list(11..19)

    Enum.each(m_2, fn msg ->
      GenServer.cast(name, msg)
    end)
  end
end
