defmodule Day7.IntcodeComputer do
  defstruct [:intcode, instruction_pointer: 0, input_buffer: [], output_buffer: []]

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

  def get_value(intcode, i, parameter_mode) do
    parameter = Enum.at(intcode, i)

    case parameter_mode do
      "0" ->
        # Parameter mode 0, position mode:
        # causes the parameter to be interpreted as a position.
        Enum.at(intcode, parameter)

      "1" ->
        # Parameter mode 1, immediate mode:
        # In immediate mode, a parameter is interpreted as a value.
        parameter
    end
  end

  @doc """
  If the first parameter is less than the second parameter, returns 1. Otherwise, returns 0.
  """
  def less_than(value_1, value_2) do
    if value_1 < value_2 do
      1
    else
      0
    end
  end

  @doc """
  If the first parameter is equal to second parameter, returns 1. Otherwise, returns 0.
  """
  def equals(value_1, value_2) do
    if value_1 == value_2 do
      1
    else
      0
    end
  end

  def parse_intcode(i, intcode, input_buffer, output_buffer) do
    {parameter_modes, opcode} =
      Enum.at(intcode, i)
      |> Integer.to_string()
      |> String.pad_leading(5, "0")
      |> String.split_at(3)

    {opcode, _} = Integer.parse(opcode)
    parameter_modes = String.reverse(parameter_modes)

    case opcode do
      1 ->
        # Add
        value_1 = get_value(intcode, i + 1, String.at(parameter_modes, 0))
        value_2 = get_value(intcode, i + 2, String.at(parameter_modes, 1))
        write_position = Enum.at(intcode, i + 3)

        intcode = List.replace_at(intcode, write_position, value_1 + value_2)

        parse_intcode(i + 4, intcode, input_buffer, output_buffer)

      2 ->
        # Multiply
        value_1 = get_value(intcode, i + 1, String.at(parameter_modes, 0))
        value_2 = get_value(intcode, i + 2, String.at(parameter_modes, 1))
        write_position = Enum.at(intcode, i + 3)

        intcode = List.replace_at(intcode, write_position, value_1 * value_2)

        parse_intcode(i + 4, intcode, input_buffer, output_buffer)

      3 ->
        # Opcode 3 takes a single integer as input and saves it to the position given by its only parameter.
        if Enum.empty?(input_buffer) do
          # Pause execution and wait for inputs
          {intcode, i, 3, input_buffer, output_buffer}
        else
          {value, input_buffer} = List.pop_at(input_buffer, 0)

          write_position = Enum.at(intcode, i + 1)

          intcode = List.replace_at(intcode, write_position, value)

          parse_intcode(i + 2, intcode, input_buffer, output_buffer)
        end

      4 ->
        # Opcode 4 outputs the value of its only parameter.
        value = get_value(intcode, i + 1, String.at(parameter_modes, 0))

        output_buffer = List.insert_at(output_buffer, -1, value)

        parse_intcode(i + 2, intcode, input_buffer, output_buffer)

      5 ->
        # Opcode 5 is jump-if-true:
        #   if the first parameter is non-zero,
        #   it sets the instruction pointer to the value from the second parameter.
        #   Otherwise, it does nothing.
        value_1 = get_value(intcode, i + 1, String.at(parameter_modes, 0))

        if value_1 != 0 do
          value_2 = get_value(intcode, i + 2, String.at(parameter_modes, 1))

          parse_intcode(value_2, intcode, input_buffer, output_buffer)
        else
          parse_intcode(i + 3, intcode, input_buffer, output_buffer)
        end

      6 ->
        # Opcode 6 is jump-if-false:
        #   if the first parameter is zero,
        #   it sets the instruction pointer to the value from the second parameter.
        #   Otherwise, it does nothing.
        value_1 = get_value(intcode, i + 1, String.at(parameter_modes, 0))

        if value_1 == 0 do
          value_2 = get_value(intcode, i + 2, String.at(parameter_modes, 1))

          parse_intcode(value_2, intcode, input_buffer, output_buffer)
        else
          parse_intcode(i + 3, intcode, input_buffer, output_buffer)
        end

      7 ->
        # Opcode 7 is less than:
        #   if the first parameter is less than the second parameter,
        #   it stores 1 in the position given by the third parameter.
        #   Otherwise, it stores 0.
        value_1 = get_value(intcode, i + 1, String.at(parameter_modes, 0))
        value_2 = get_value(intcode, i + 2, String.at(parameter_modes, 1))
        write_position = Enum.at(intcode, i + 3)

        intcode = List.replace_at(intcode, write_position, less_than(value_1, value_2))

        parse_intcode(i + 4, intcode, input_buffer, output_buffer)

      8 ->
        # Opcode 8 is equals:
        #   if the first parameter is equal to the second parameter,
        #   it stores 1 in the position given by the third parameter.
        #   Otherwise, it stores 0.
        value_1 = get_value(intcode, i + 1, String.at(parameter_modes, 0))
        value_2 = get_value(intcode, i + 2, String.at(parameter_modes, 1))
        write_position = Enum.at(intcode, i + 3)

        intcode = List.replace_at(intcode, write_position, equals(value_1, value_2))

        parse_intcode(i + 4, intcode, input_buffer, output_buffer)

      99 ->
        # Halt
        {intcode, i, 99, input_buffer, output_buffer}

      x ->
        IO.puts("Something went wrong: #{x}")
        {intcode, i, x, input_buffer, output_buffer}
    end
  end
end
