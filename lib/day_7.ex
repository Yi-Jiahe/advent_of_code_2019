defmodule DaySeven do
  defmodule IntcodeComputer do
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
  end

  def find_amplifier_output_signal(phase_setting_sequence, intcode, input_buffer) do
    if Enum.empty?(phase_setting_sequence) do
      Enum.at(input_buffer, 0)
    else
      {phase_setting, phase_setting_sequence} = List.pop_at(phase_setting_sequence, 0)
      input_buffer = List.insert_at(input_buffer, 0, phase_setting)
      {_, _, output_buffer} = IntcodeComputer.parse_intcode(0, intcode, input_buffer, [])
      find_amplifier_output_signal(phase_setting_sequence, intcode, output_buffer)
    end
  end

  def find_thruster_signal(phase_setting_sequence, intcode) do
    find_amplifier_output_signal(phase_setting_sequence, intcode, [0])
  end

  def generate_phase_setting_sequences() do
    do_loop = fn ->
      phase_settings = {0, 1, 2, 3, 4}
      phase_settings_sequence = []
      for i <- 0..tuple_size(phase_settings)-1 do
        phase_settings_sequence = phase_settings_sequence
        |> List.insert_at(-1, elem(phase_settings, i))
        phase_settings = Tuple.delete_at(phase_settings, i)
        for i <- 0..tuple_size(phase_settings)-1 do
          phase_settings_sequence = phase_settings_sequence
          |> List.insert_at(-1, elem(phase_settings, i))
          phase_settings = Tuple.delete_at(phase_settings, i)
          for i <- 0..tuple_size(phase_settings)-1 do
            phase_settings_sequence = phase_settings_sequence
            |> List.insert_at(-1, elem(phase_settings, i))
            phase_settings = Tuple.delete_at(phase_settings, i)
            for i <- 0..tuple_size(phase_settings)-1 do
              phase_settings_sequence = phase_settings_sequence
              |> List.insert_at(-1, elem(phase_settings, i))
              phase_settings = Tuple.delete_at(phase_settings, i)
              phase_settings_sequence
              |> List.insert_at(-1, elem(phase_settings, 0))
              |> List.to_tuple()
            end
          end
        end
      end
    end

    do_loop.()
    |> List.flatten()
    |> Enum.map(&Tuple.to_list(&1))
  end

  def find_max_thruster_signal(intcode) do
    generate_phase_setting_sequences()
    |> Enum.map(&find_thruster_signal(&1, intcode))
    |> Enum.reduce(fn element, acc -> max(element, acc) end)
  end


  def main(filename \\ "./puzzle_inputs/day_7/amplifier_controller_software.txt") do
    case File.read(filename) do
      {:ok, body} ->
        intcode = IntcodeComputer.parse_intcode_from_string(body)

        max_thruster_signal = find_max_thruster_signal(intcode)
        IO.puts("The highest signal that can be sent to the thrusters is #{max_thruster_signal}")
      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
