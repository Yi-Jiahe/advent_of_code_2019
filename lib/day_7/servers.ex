defmodule Day7.Server do
  alias Day7.IntcodeComputer

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

  def write_with_opcode(server, values, opcode) do
    GenServer.cast(server, {:write_with_opcode, values, opcode})
  end

  # Write to input buffer
  def add_output_process(server, pid) do
    GenServer.cast(server, {:add_output_process, pid})
  end

  def start(server) do
    GenServer.cast(server, {:start})
  end

  defp fetch_intcode_computer_args(state) do
    {:ok, intcode_computer} = Map.fetch(state, :intcode_computer)

    {:ok, i} = Map.fetch(intcode_computer, :instruction_pointer)
    {:ok, intcode} = Map.fetch(intcode_computer, :intcode)
    {:ok, input_buffer} = Map.fetch(intcode_computer, :input_buffer)
    {:ok, output_buffer} = Map.fetch(intcode_computer, :output_buffer)

    {intcode_computer, i, intcode, input_buffer, output_buffer}
  end

  defp dump_output_buffer(opcode, output_buffer, output_processes) do
    for pid <- output_processes do
      write_with_opcode(pid, output_buffer, opcode)
    end
  end

  # Server API
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
    {intcode_computer, i, intcode, input_buffer, output_buffer} =
      fetch_intcode_computer_args(state)

    input_buffer = Enum.concat([input_buffer, values])

    {intcode, i, opcode, input_buffer, output_buffer} =
      IntcodeComputer.parse_intcode(i, intcode, input_buffer, output_buffer)

    {:ok, output_processes} = Map.fetch(state, :output_processes)

    if !Enum.empty?(output_buffer) do
      dump_output_buffer(opcode, output_buffer, output_processes)
    end

    new_intcode_computer = %IntcodeComputer{
      intcode: intcode,
      instruction_pointer: i,
      input_buffer: input_buffer,
      output_buffer: []
    }

    intcode_computer = Map.merge(intcode_computer, new_intcode_computer)

    new_state = Map.replace!(state, :intcode_computer, intcode_computer)
    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:write_with_opcode, values, _opcode}, state) do
    {intcode_computer, i, intcode, input_buffer, output_buffer} =
      fetch_intcode_computer_args(state)

    input_buffer = Enum.concat([input_buffer, values])

    {intcode, i, opcode, input_buffer, output_buffer} =
      IntcodeComputer.parse_intcode(i, intcode, input_buffer, output_buffer)

    {:ok, output_processes} = Map.fetch(state, :output_processes)

    if !Enum.empty?(output_buffer) do
      dump_output_buffer(opcode, output_buffer, output_processes)
    end

    new_intcode_computer = %IntcodeComputer{
      intcode: intcode,
      instruction_pointer: i,
      input_buffer: input_buffer,
      output_buffer: []
    }

    intcode_computer = Map.merge(intcode_computer, new_intcode_computer)

    new_state = Map.replace!(state, :intcode_computer, intcode_computer)
    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:add_output_process, pid}, state) do
    {_, new_state} =
      Map.get_and_update!(state, :output_processes, fn p -> {p, List.insert_at(p, -1, pid)} end)

    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:start}, state) do
    {intcode_computer, i, intcode, input_buffer, output_buffer} =
      fetch_intcode_computer_args(state)

    {intcode, i, opcode, input_buffer, output_buffer} =
      IntcodeComputer.parse_intcode(i, intcode, input_buffer, output_buffer)

    {:ok, output_processes} = Map.fetch(state, :output_processes)
    dump_output_buffer(opcode, output_buffer, output_processes)

    new_intcode_computer = %IntcodeComputer{
      intcode: intcode,
      instruction_pointer: i,
      input_buffer: input_buffer,
      output_buffer: []
    }

    intcode_computer = Map.merge(intcode_computer, new_intcode_computer)

    new_state = Map.replace!(state, :intcode_computer, intcode_computer)
    {:noreply, new_state}
  end
end

defmodule Day7.Thrusters do
  use GenServer

  # Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, 0, opts)
  end

  # Server API
  @impl true
  def init(state) do
    {:ok, state, 5000}
  end

  @impl true
  def handle_cast({:write_with_opcode, values, opcode}, state) do
    state =
      if opcode == 99 do
        max(Enum.at(values, -1), state)
      else
        state
      end

    {:noreply, state, 5000}
  end

  @impl true
  def handle_info(:timeout, state) do
    IO.puts("Max thruster value: #{state}")
    {:noreply, state}
  end
end
