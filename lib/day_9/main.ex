defmodule Day9.Main do
  alias Day9.IntcodeComputer
  alias Day9.IntcodeComputer.State

  def main(filename \\ "./puzzle_inputs/day_9/BOOST.txt") do
    case File.read(filename) do
      {:ok, body} ->
        intcode = IntcodeComputer.parse_intcode_from_string(body)

        output_buffer =
          IntcodeComputer.step(%State{intcode: intcode, input_buffer: [1]})
          |> Map.fetch!(:output_buffer)

        IO.inspect(output_buffer)

        # IO.puts("BOOST keycode#{keycode}")

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
