defmodule DayFive do
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
    {parameter_modes, opcode} = Enum.at(intcode, i)
    |> Integer.to_string()
    |> String.pad_leading(5, "0")
    |> String.split_at(3)
    {opcode, _} = Integer.parse(opcode)
    parameter_modes = String.reverse(parameter_modes)

    case opcode do
      1 ->
        # Add
        value_1 = get_value(intcode, i+1, String.at(parameter_modes, 0))
        value_2 = get_value(intcode, i+2, String.at(parameter_modes, 1))
        write_position = Enum.at(intcode, i+3)

        intcode = List.replace_at(intcode, write_position, value_1 + value_2)

        parse_intcode(i+4, intcode, input_buffer, output_buffer)
      2 ->
        # Multiply
        value_1 = get_value(intcode, i+1, String.at(parameter_modes, 0))
        value_2 = get_value(intcode, i+2, String.at(parameter_modes, 1))
        write_position = Enum.at(intcode, i+3)

        intcode = List.replace_at(intcode, write_position, value_1 * value_2)

        parse_intcode(i+4, intcode, input_buffer, output_buffer)
      3 ->
        # Opcode 3 takes a single integer as input and saves it to the position given by its only parameter.
        if Enum.empty?(input_buffer) do
          IO.puts("Ran out of inputs")
        else
          {value, input_buffer} = List.pop_at(input_buffer, 0)

          write_position = Enum.at(intcode, i+1)

          intcode = List.replace_at(intcode, write_position, value)

          parse_intcode(i+2, intcode, input_buffer, output_buffer)
        end
      4 ->
        # Opcode 4 outputs the value of its only parameter.
        value = get_value(intcode, i+1, String.at(parameter_modes, 0))

        output_buffer = List.insert_at(output_buffer, -1, value)

        parse_intcode(i+2, intcode, input_buffer, output_buffer)
      5 ->
        # Opcode 5 is jump-if-true:
        #   if the first parameter is non-zero,
        #   it sets the instruction pointer to the value from the second parameter.
        #   Otherwise, it does nothing.
        value_1 = get_value(intcode, i+1, String.at(parameter_modes, 0))
        if value_1 != 0 do
          value_2 = get_value(intcode, i+2, String.at(parameter_modes, 1))

          parse_intcode(value_2, intcode, input_buffer, output_buffer)
        else
          parse_intcode(i+3, intcode, input_buffer, output_buffer)
        end
      6 ->
        # Opcode 6 is jump-if-false:
        #   if the first parameter is zero,
        #   it sets the instruction pointer to the value from the second parameter.
        #   Otherwise, it does nothing.
        value_1 = get_value(intcode, i+1, String.at(parameter_modes, 0))
        if value_1 == 0 do
          value_2 = get_value(intcode, i+2, String.at(parameter_modes, 1))

          parse_intcode(value_2, intcode, input_buffer, output_buffer)
        else
          parse_intcode(i+3, intcode, input_buffer, output_buffer)
        end
      7 ->
        # Opcode 7 is less than:
        #   if the first parameter is less than the second parameter,
        #   it stores 1 in the position given by the third parameter.
        #   Otherwise, it stores 0.
        value_1 = get_value(intcode, i+1, String.at(parameter_modes, 0))
        value_2 = get_value(intcode, i+2, String.at(parameter_modes, 1))
        write_position = Enum.at(intcode, i+3)

        intcode = List.replace_at(intcode, write_position, less_than(value_1, value_2))

        parse_intcode(i+4, intcode, input_buffer, output_buffer)
      8 ->
        # Opcode 8 is equals:
        #   if the first parameter is equal to the second parameter,
        #   it stores 1 in the position given by the third parameter.
        #   Otherwise, it stores 0.
        value_1 = get_value(intcode, i+1, String.at(parameter_modes, 0))
        value_2 = get_value(intcode, i+2, String.at(parameter_modes, 1))
        write_position = Enum.at(intcode, i+3)

        intcode = List.replace_at(intcode, write_position, equals(value_1, value_2))

        parse_intcode(i+4, intcode, input_buffer, output_buffer)
      99 ->
        # Halt
        {intcode, i, output_buffer}
      x ->
        IO.puts("Something went wrong: #{x}")
        {intcode, i, output_buffer}
    end
  end

  def main(filename \\ "./puzzle_inputs/day_5/diagnostic_program.txt") do
    case File.read(filename) do
      {:ok, body} ->
        intcode = body
        |> String.split(",", trim: true)
        |> Enum.map(&Integer.parse/1)
        |> Enum.map(fn {x, _} -> x end)

        intcode_part_one = intcode
        {intcode_result_part_one, i, output_buffer} = parse_intcode(0, intcode_part_one, [1], [])
        diagnostic_code = Enum.at(output_buffer, -1)
        IO.puts("The program produced a diagnostic code of #{diagnostic_code}.")
        IO.inspect(intcode_result_part_one)
        IO.inspect(i)
        IO.inspect(output_buffer)

        intcode_part_two = intcode
        {intcode_result_part_two, i, output_buffer} = parse_intcode(0, intcode_part_two, [5], [])
        if Enum.count(output_buffer) != 1 do
          IO.puts("Panic! More outputs than just the diagnostic code")
        end
        diagnostic_code = Enum.at(output_buffer, -1)
        IO.puts("The program produced a diagnostic code of #{diagnostic_code}.")
        IO.inspect(intcode_result_part_two)
        IO.inspect(i)
        IO.inspect(output_buffer)
      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end
end
