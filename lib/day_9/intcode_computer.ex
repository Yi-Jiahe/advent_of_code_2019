defmodule Day9.IntcodeComputer do
  defmodule State do
    defstruct [
      :intcode,
      instruction_pointer: 0,
      relative_base: 0,
      input_buffer: [],
      output_buffer: []
    ]
  end

  def parse_intcode_from_string(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn {x, _} -> x end)
  end

  def provide_inputs(intcode, noun, verb) do
    intcode
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end

  defp read_address(state, address) do
    intcode = Map.fetch!(state, :intcode)

    if Enum.count_until(intcode, address + 1) <= address, do: 0, else: Enum.at(intcode, address)
  end

  defp write_address(state, address, value) do
    intcode = Map.fetch!(state, :intcode)

    length = Enum.count_until(intcode, address + 1)

    intcode =
      case {length <= address, value} do
        {false, _} -> intcode
        {_, 0} -> intcode
        {true, _} -> Enum.concat([intcode, List.duplicate(0, address - length + 1)])
      end
      |> List.replace_at(address, value)

    struct(state, intcode: intcode)
  end

  defp get_value(state, address, parameter_mode) do
    parameter = read_address(state, address)

    case parameter_mode do
      "0" ->
        # Parameter mode 0, position mode:
        # causes the parameter to be interpreted as a position.
        read_address(state, parameter)

      "1" ->
        # Parameter mode 1, immediate mode:
        # In immediate mode, a parameter is interpreted as a value.
        parameter

      "2" ->
        # Paramter mode 2, relative mode:
        # The parameter is interpreted as a position.
        # Parameters in relative mode can be read from or written to.
        # The position is counted from a value called the relative base.
        # The relative base starts at 0.
        # The address a relative mode parameter refers to is itself plus the current relative base.
        relative_base = Map.fetch!(state, :relative_base)
        read_address(state, parameter + relative_base)
    end
  end

  defp get_write_address(state, address, parameter_mode) do
    write_address = read_address(state, address)

    case parameter_mode do
      "0" ->
        # Parameter mode 0, position mode:
        # causes the parameter to be interpreted as a position.
        write_address

      "2" ->
        # Paramter mode 2, relative mode:
        # The parameter is interpreted as a position.
        # Parameters in relative mode can be read from or written to.
        # The position is counted from a value called the relative base.
        # The relative base starts at 0.
        # The address a relative mode parameter refers to is itself plus the current relative base.
        relative_base = Map.fetch!(state, :relative_base)
        write_address + relative_base
    end
  end

  defp less_than(value_1, value_2) do
    if value_1 < value_2, do: 1, else: 0
  end

  defp equals(value_1, value_2) do
    if value_1 == value_2, do: 1, else: 0
  end

  def step(state) do
    intcode = Map.fetch!(state, :intcode)
    i = Map.fetch!(state, :instruction_pointer)

    {parameter_modes, opcode} =
      read_address(state, i)
      |> Integer.to_string()
      |> String.pad_leading(5, "0")
      |> String.split_at(3)

    {opcode, _} = Integer.parse(opcode)
    parameter_modes = String.reverse(parameter_modes)

    # IO.inspect(state)
    # IO.inspect(opcode)

    case opcode do
      1 ->
        # Add
        value_1 = get_value(state, i + 1, String.at(parameter_modes, 0))
        value_2 = get_value(state, i + 2, String.at(parameter_modes, 1))
        write_position = get_write_address(state, i + 3, String.at(parameter_modes, 2))

        new_state =
          state
          |> write_address(write_position, value_1 + value_2)
          |> struct(instruction_pointer: i + 4)

        step(new_state)

      2 ->
        # Multiply
        value_1 = get_value(state, i + 1, String.at(parameter_modes, 0))
        value_2 = get_value(state, i + 2, String.at(parameter_modes, 1))
        write_position = get_write_address(state, i + 3, String.at(parameter_modes, 2))

        new_state =
          state
          |> write_address(write_position, value_1 * value_2)
          |> struct(instruction_pointer: i + 4)

        step(new_state)

      3 ->
        # Opcode 3 takes a single integer as input and saves it to the position given by its only parameter.
        input_buffer = Map.fetch!(state, :input_buffer)

        if Enum.empty?(input_buffer) do
          # Pause execution and wait for inputs
          state
        else
          {value, input_buffer} = List.pop_at(input_buffer, 0)

          write_position = get_write_address(state, i + 1, String.at(parameter_modes, 0))

          new_state =
            state
            |> write_address(write_position, value)
            |> struct(instruction_pointer: i + 2, input_buffer: input_buffer)

          step(new_state)
        end

      4 ->
        # Opcode 4 outputs the value of its only parameter.
        output_buffer = Map.fetch!(state, :output_buffer)

        value = get_value(state, i + 1, String.at(parameter_modes, 0))

        output_buffer = List.insert_at(output_buffer, -1, value)

        new_state = struct(state, instruction_pointer: i + 2, output_buffer: output_buffer)

        step(new_state)

      5 ->
        # Opcode 5 is jump-if-true:
        #   if the first parameter is non-zero,
        #   it sets the instruction pointer to the value from the second parameter.
        #   Otherwise, it does nothing.
        value = get_value(state, i + 1, String.at(parameter_modes, 0))

        new_i =
          if value != 0, do: get_value(state, i + 2, String.at(parameter_modes, 1)), else: i + 3

        new_state = struct(state, instruction_pointer: new_i)

        step(new_state)

      6 ->
        # Opcode 6 is jump-if-false:
        #   if the first parameter is zero,
        #   it sets the instruction pointer to the value from the second parameter.
        #   Otherwise, it does nothing.
        value = get_value(state, i + 1, String.at(parameter_modes, 0))

        new_i = if value == 0, do: get_value(state, i + 2, String.at(parameter_modes, 1)), else: i + 3

        new_state = struct(state, instruction_pointer: new_i)

        step(new_state)

      7 ->
        # Opcode 7 is less than:
        #   if the first parameter is less than the second parameter,
        #   it stores 1 in the position given by the third parameter.
        #   Otherwise, it stores 0.
        value_1 = get_value(state, i + 1, String.at(parameter_modes, 0))
        value_2 = get_value(state, i + 2, String.at(parameter_modes, 1))
        write_position = get_write_address(state, i + 3, String.at(parameter_modes, 2))

        new_state =
          state
          |> write_address(write_position, less_than(value_1, value_2))
          |> struct(instruction_pointer: i + 4)

        step(new_state)

      8 ->
        # Opcode 8 is equals:
        #   if the first parameter is equal to the second parameter,
        #   it stores 1 in the position given by the third parameter.
        #   Otherwise, it stores 0.
        value_1 = get_value(state, i + 1, String.at(parameter_modes, 0))
        value_2 = get_value(state, i + 2, String.at(parameter_modes, 1))
        write_position = get_write_address(state, i + 3, String.at(parameter_modes, 2))

        new_state =
          state
          |> write_address(write_position, equals(value_1, value_2))
          |> struct(instruction_pointer: i + 4)

        step(new_state)

      9 ->
        # Opcode 9 adjusts the relative base by the value of its only parameter.
        # The relative base increases (or decreases, if the value is negative)
        # by the value of the parameter.
        relative_base = Map.fetch!(state, :relative_base)

        value = get_value(state, i + 1, String.at(parameter_modes, 0))

        new_state =
          struct(state, instruction_pointer: i + 2, relative_base: relative_base + value)

        step(new_state)

      99 ->
        # Halt
        state

      x ->
        IO.puts("Something went wrong: #{x}")
        state
    end
  end
end
