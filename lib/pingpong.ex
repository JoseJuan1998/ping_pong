defmodule Pingpong do
  def start() do
    init_state()

    make_process()
    |> run()

    receive do
      {:DOWN, _ref, :process, pid, reason} ->
        IO.puts("Process was killed because #{Atom.to_string(reason)}")
        IO.inspect(Process.alive?(pid))
        start()
    end
  end

  defp make_process() do
    ping = spawn(Ping, :ping, [])
    pong = spawn(Pong, :pong, [])
    {ping, pong}
  end

  defp run({ping, pong}) do
    send(ping, {:ping, pong})
    Process.send_after(ping, :boom, 5_000)
    Process.monitor(ping)
    Process.monitor(pong)
    IO.puts("Game started")
  end

  defp init_state() do
    case Process.whereis(:state) do
      nil -> State.start()
      _ -> nil
    end
  end
end
