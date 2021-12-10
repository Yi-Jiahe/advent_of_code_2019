defmodule Day9Test do
  alias Day9.IntcodeComputer
  alias Day9.IntcodeComputer.State

  use ExUnit.Case

  test "Part 1 Example 1" do
    program = [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
    # takes no input and produces a copy of itself as output.

    intcode =
      IntcodeComputer.step(%State{intcode: program})
      |> Map.fetch!(:intcode)

    assert List.starts_with?(intcode, program)
  end

  test "Part 1 Example 2" do
    # should output a 16-digit number.
    intcode = [1102, 34_915_192, 34_915_192, 7, 4, 7, 99, 0]

    output =
      IntcodeComputer.step(%State{intcode: intcode})
      |> Map.fetch!(:output_buffer)
      |> List.last()

    n_digits =
      output
      |> to_string()
      |> String.length()

    assert n_digits == 16

    # Inspecting the program, the output should be the product of the values at addresses 1 and 2
    assert output == Enum.at(intcode, 1) * Enum.at(intcode, 2)
  end

  test "Part 1 Example 3" do
    # should output the large number in the middle.
    intcode = [104, 1_125_899_906_842_624, 99]

    output =
      IntcodeComputer.step(%State{intcode: intcode})
      |> Map.fetch!(:output_buffer)
      |> List.last()

    assert output == 1_125_899_906_842_624
  end
end
