defmodule Day9.Main do
  alias Day9.IntcodeComputer
  alias Day9.IntcodeComputer.State

  def main(filename \\ "./puzzle_inputs/day_9/BOOST.txt") do
    case File.read(filename) do
      {:ok, body} ->
        intcode = IntcodeComputer.parse_intcode_from_string(body)

        keycode =
          IntcodeComputer.step(%State{intcode: intcode, input_buffer: [1]})
          |> Map.fetch!(:output_buffer)
          |> List.last()

        IO.puts("BOOST keycode #{keycode}")

        coordinates =
          IntcodeComputer.step(%State{intcode: intcode, input_buffer: [2]})
          |> Map.fetch!(:output_buffer)

        IO.puts("The coordinates of the distress signal are")
        Utils.print_int_list(coordinates)
      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
