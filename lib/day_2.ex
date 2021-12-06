defmodule DayTwo do
  def provide_inputs(intcode, noun, verb) do
    intcode = List.replace_at(intcode, 1, noun)
    intcode = List.replace_at(intcode, 2, verb)
    intcode
  end

  def parse_intcode(i, intcode) do
    case Enum.at(intcode, i) do
      1 ->
        {position_1, position_2, position_3}
          = {Enum.at(intcode, i+1), Enum.at(intcode, i+2), Enum.at(intcode, i+3)}
        {value_1, value_2} = {Enum.at(intcode, position_1), Enum.at(intcode, position_2)}
        intcode = List.replace_at(intcode, position_3, value_1 + value_2)
        parse_intcode(i+4, intcode)
      2 ->
        {position_1, position_2, position_3}
          = {Enum.at(intcode, i+1), Enum.at(intcode, i+2), Enum.at(intcode, i+3)}
        {value_1, value_2} = {Enum.at(intcode, position_1), Enum.at(intcode, position_2)}
        intcode = List.replace_at(intcode, position_3, value_1 * value_2)
        parse_intcode(i+4, intcode)
      99 -> {Enum.at(intcode, 0), intcode}
      x -> IO.puts("Something went wrong: #{x}")
    end
  end

  def main(filename \\ "./puzzle_inputs/day_2/gravity_assist_program.txt") do
    case File.read(filename) do
      {:ok, body} ->
        intcode = body
        |> String.split(",", trim: true)
        |> Enum.map(&Integer.parse/1)
        |> Enum.map(fn {optcode, _} -> optcode end)

        intcode_part_one = provide_inputs(intcode, 12, 2)
        {answer, intcode_result_part_one} = parse_intcode(0, intcode_part_one)
        IO.puts("The value at position 0 is #{answer}")
        IO.inspect(intcode_result_part_one)

        for noun <- 1..100 do
          for verb <- 1..100 do
            intcode_part_two = provide_inputs(intcode, noun, verb)
            {answer, _} = parse_intcode(0, intcode_part_two)
            if answer == 19690720 do
              IO.puts("Answer: #{100 * noun + verb}")
            end
          end
        end

      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end
end
