defmodule DaySeven do
  alias Day7.IntcodeComputer

  defmodule PartOne do
    def find_amplifier_output_signal(phase_setting_sequence, intcode, input_buffer) do
      if Enum.empty?(phase_setting_sequence) do
        Enum.at(input_buffer, 0)
      else
        {phase_setting, phase_setting_sequence} = List.pop_at(phase_setting_sequence, 0)
        input_buffer = List.insert_at(input_buffer, 0, phase_setting)
        {_, _, _, _, output_buffer} = IntcodeComputer.parse_intcode(0, intcode, input_buffer, [])
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

        for i <- 0..(tuple_size(phase_settings) - 1) do
          phase_settings_sequence =
            phase_settings_sequence
            |> List.insert_at(-1, elem(phase_settings, i))

          phase_settings = Tuple.delete_at(phase_settings, i)

          for i <- 0..(tuple_size(phase_settings) - 1) do
            phase_settings_sequence =
              phase_settings_sequence
              |> List.insert_at(-1, elem(phase_settings, i))

            phase_settings = Tuple.delete_at(phase_settings, i)

            for i <- 0..(tuple_size(phase_settings) - 1) do
              phase_settings_sequence =
                phase_settings_sequence
                |> List.insert_at(-1, elem(phase_settings, i))

              phase_settings = Tuple.delete_at(phase_settings, i)

              for i <- 0..(tuple_size(phase_settings) - 1) do
                phase_settings_sequence =
                  phase_settings_sequence
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
  end

  defmodule PartTwo do
    def find_amplifier_output_signal(phase_setting_sequence, intcode, thrusters) do
      phase_setting = Enum.at(phase_setting_sequence, 0)
      intcode_computer = %IntcodeComputer{intcode: intcode, input_buffer: [phase_setting, 0]}
      {:ok, a} = Day7.Server.start_link(intcode_computer, [])
      phase_setting = Enum.at(phase_setting_sequence, 1)
      intcode_computer = %IntcodeComputer{intcode: intcode, input_buffer: [phase_setting]}
      {:ok, b} = Day7.Server.start_link(intcode_computer, [])
      phase_setting = Enum.at(phase_setting_sequence, 2)
      intcode_computer = %IntcodeComputer{intcode: intcode, input_buffer: [phase_setting]}
      {:ok, c} = Day7.Server.start_link(intcode_computer, [])
      phase_setting = Enum.at(phase_setting_sequence, 3)
      intcode_computer = %IntcodeComputer{intcode: intcode, input_buffer: [phase_setting]}
      {:ok, d} = Day7.Server.start_link(intcode_computer, [])
      phase_setting = Enum.at(phase_setting_sequence, 4)
      intcode_computer = %IntcodeComputer{intcode: intcode, input_buffer: [phase_setting]}
      {:ok, e} = Day7.Server.start_link(intcode_computer, [])

      Day7.Server.add_output_process(a, b)
      Day7.Server.add_output_process(b, c)
      Day7.Server.add_output_process(c, d)
      Day7.Server.add_output_process(d, e)
      Day7.Server.add_output_process(e, a)
      Day7.Server.add_output_process(e, thrusters)

      Day7.Server.start(a)

    end

    def find_thruster_signal(phase_setting_sequence, intcode, thrusters) do
      find_amplifier_output_signal(phase_setting_sequence, intcode, thrusters)
    end

    def generate_phase_setting_sequences() do
      do_loop = fn ->
        phase_settings = {5, 6, 7, 8, 9}
        phase_settings_sequence = []

        for i <- 0..(tuple_size(phase_settings) - 1) do
          phase_settings_sequence =
            phase_settings_sequence
            |> List.insert_at(-1, elem(phase_settings, i))

          phase_settings = Tuple.delete_at(phase_settings, i)

          for i <- 0..(tuple_size(phase_settings) - 1) do
            phase_settings_sequence =
              phase_settings_sequence
              |> List.insert_at(-1, elem(phase_settings, i))

            phase_settings = Tuple.delete_at(phase_settings, i)

            for i <- 0..(tuple_size(phase_settings) - 1) do
              phase_settings_sequence =
                phase_settings_sequence
                |> List.insert_at(-1, elem(phase_settings, i))

              phase_settings = Tuple.delete_at(phase_settings, i)

              for i <- 0..(tuple_size(phase_settings) - 1) do
                phase_settings_sequence =
                  phase_settings_sequence
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

    def find_max_thruster_signal(intcode, thrusters) do
      generate_phase_setting_sequences()
      |> Enum.each(&find_thruster_signal(&1, intcode, thrusters))
    end
  end

  def main(filename \\ "./puzzle_inputs/day_7/amplifier_controller_software.txt") do

    case File.read(filename) do
      {:ok, body} ->
        intcode = IntcodeComputer.parse_intcode_from_string(body)

        max_thruster_signal = PartOne.find_max_thruster_signal(intcode)
        IO.puts("The highest signal that can be sent to the thrusters is #{max_thruster_signal}")

        {:ok, thrusters} = Day7.Thrusters.start_link([])
        PartTwo.find_max_thruster_signal(intcode, thrusters)
      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
