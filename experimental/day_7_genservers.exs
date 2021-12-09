defmodule Experimental.Day7.IntcodeComputer do
  defstruct [:intcode, instruction_pointer: 0, input_buffer: [], output_buffer: []]

  def ingest_input_buffer(intcode, i, input_buffer, output_buffer) do
    if Enum.empty?(input_buffer) do
      {intcode, i, input_buffer, output_buffer}
    else
      {value, input_buffer} = List.pop_at(input_buffer, 0)
      intcode = List.replace_at(intcode, i, value)
      i = if i >= Enum.count(intcode) do
        0
      else
        i + 1
      end
      output_buffer = List.insert_at(output_buffer, -1, value)
      ingest_input_buffer(intcode, i, input_buffer, output_buffer)
    end
  end
end

defmodule Experimental.Day7.IntcodeComputer.Server do
  alias Experimental.Day7.IntcodeComputer

  use GenServer

  defmodule ServerState do
    @enforce_keys [:intcode_computer]
    defstruct [:intcode_computer, output_processes: []]
  end

  # Client API
  def start_link(intcode_computer, opts) do
    GenServer.start_link(__MODULE__, %ServerState{intcode_computer: intcode_computer}, opts)
  end

  def lookup(server, field) do
    GenServer.call(server, {:lookup, field})
  end

  def last_opcode(server) do
    GenServer.call(server, {:last_opcode})
  end

  # Read from output buffer
  def read(server) do
    GenServer.call(server, {:read})
  end

  # Write to input buffer
  def write(server, values) do
    GenServer.cast(server, {:write, values})
  end

  # Write to input buffer
  def add_output_process(server, pid) do
    GenServer.cast(server, {:add_output_process, pid})
  end

  defp dump_output_buffer(output_buffer, output_processes) do
    for pid <- output_processes do
      write(pid, output_buffer)
    end
  end

  #Server API
  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  @impl true
  def handle_call({:lookup, field}, _from, state) do
    {:ok, intcode_computer} = Map.fetch(state, :intcode_computer)
    {:reply, Map.fetch(intcode_computer, field), state}
  end

  @impl true
  def handle_call({:last_opcode}, _from, state) do
    {:ok, intcode_computer} = Map.fetch(state, :intcode_computer)
    {:ok, intcode} = Map.fetch(intcode_computer, :intcode)
    {:ok, i} = Map.fetch(intcode_computer, :instruction_pointer)
    opcode = Enum.at(intcode, i)
    {:reply, opcode, state}
  end

  @impl true
  def handle_call({:read}, _from, state) do
    {:ok, intcode_computer} = Map.fetch(state, :intcode_computer)
    {:ok, output_buffer} = Map.fetch(intcode_computer, :output_buffer)

    intcode_computer = Map.replace!(intcode_computer, :output_buffer, [])
    new_state = Map.replace!(state, :intcode_computer, intcode_computer)
    {:reply, output_buffer, new_state}
  end

  @impl true
  def handle_cast({:write, values}, state) do
    {:ok, intcode_computer} = Map.fetch(state, :intcode_computer)
    {:ok, input_buffer} = Map.fetch(intcode_computer, :input_buffer)
    input_buffer = Enum.concat([input_buffer, values])

    {:ok, intcode} = Map.fetch(intcode_computer, :intcode)
    {:ok, i} = Map.fetch(intcode_computer, :instruction_pointer)
    {:ok, output_buffer} = Map.fetch(intcode_computer, :output_buffer)

    {intcode, i, input_buffer, output_buffer} = IntcodeComputer.ingest_input_buffer(intcode, i, input_buffer, output_buffer)

    {:ok, output_processes} = Map.fetch(state, :output_processes)
    dump_output_buffer(output_buffer, output_processes)

    new_intcode_computer = %IntcodeComputer{intcode: intcode, instruction_pointer: i, input_buffer: input_buffer, output_buffer: []}
    intcode_computer = Map.merge(intcode_computer, new_intcode_computer)

    new_state = Map.replace!(state, :intcode_computer, intcode_computer)
    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:add_output_process, pid}, state) do
    {_, new_state} = Map.get_and_update!(state, :output_processes, fn p -> {p, List.insert_at(p, -1, pid)} end)
    {:noreply, new_state}
  end
end

defmodule Thrusters do
  use GenServer

    # Client API
    def start_link(opts) do
      GenServer.start_link(__MODULE__, [], opts)
    end

    #Server API
    @impl true
    def init(state) do
      {:ok, state}
    end

    @impl true
    def handle_cast({:write, values}, state) do
      new_state = Enum.concat([state, values])
      IO.puts("Thruster receive")
      IO.inspect(new_state)
      {:noreply, new_state}
    end
end

defmodule Experimental.Day7.Main do
  alias Experimental.Day7.IntcodeComputer
  alias Experimental.Day7.IntcodeComputer.Server

  def main do
    intcode_computer = %IntcodeComputer{intcode: [1, 44, 55, 4, 0], input_buffer: [3], output_buffer: [332]}
    {:ok, a} = Server.start_link(intcode_computer, [])
    intcode_computer = %IntcodeComputer{intcode: [1, 44, 55, 4, 0], input_buffer: [1]}
    {:ok, b} = Server.start_link(intcode_computer, [])
    {:ok, thrusters} = Thrusters.start_link([])

    Server.add_output_process(a, b)
    Server.add_output_process(b, thrusters)

    Server.write(a, [1, 2, 3])

    Server.write(a, [3, 4])

    opcode = Server.last_opcode(a)
    IO.inspect(opcode)
  end
end

Experimental.Day7.Main.main()
