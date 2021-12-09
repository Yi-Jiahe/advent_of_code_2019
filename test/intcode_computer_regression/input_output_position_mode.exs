defmodule IntcodeComputerRegressionTest do
  alias Day9.IntcodeComputer
  alias Day9.IntcodeComputer.State

  use ExUnit.Case

  test "Take input" do
    # The program 3,0,4,0,99 outputs whatever it gets as input, then halts.
    intcode = [3, 0, 4, 0, 99]

    for _ <- 1..10 do
      input = :rand.uniform(999_999)

      output_buffer =
        IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
        |> Map.fetch!(:output_buffer)

      assert Enum.count(output_buffer) == 1
      assert Enum.at(output_buffer, 0) == input
    end
  end

  test "Immediate mode" do
    intcode = [1002, 4, 3, 4, 33]

    intcode =
      IntcodeComputer.step(%State{intcode: intcode})
      |> Map.fetch!(:intcode)

    assert intcode == [1002, 4, 3, 4, 99]
  end

  test "Negative values" do
    intcode = [1101, 100, -1, 4, 0]

    intcode =
      IntcodeComputer.step(%State{intcode: intcode})
      |> Map.fetch!(:intcode)

    assert intcode == [1101, 100, -1, 4, 99]
  end
end
