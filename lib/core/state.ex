defmodule State do
  def start() do
    pid = spawn_link(State.Internal, :loop, [0])
    Process.register(pid, :state)
  end

  def get() do
    send(:state, {:get, self()})
    receiver()
  end

  def set(new_state) do
    send(:state, {:add, self(), new_state})
  end

  defp receiver() do
    receive do
      state -> state
    end
  end
end


defmodule State.Internal do
  def loop(state \\ 0) do
    receiver(state)
  end

  defp receiver(state) do
    receive do
      {:add, _from, val} -> loop(state + val)
      {:get, from} ->
        send(from, state)
        loop(state)
    end
  end
end
