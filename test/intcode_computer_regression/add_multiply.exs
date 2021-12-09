defmodule IntcodeComputerRegressionTest do
  alias Day9.IntcodeComputer
  alias Day9.IntcodeComputer.State

  use ExUnit.Case

  test "Day 2 Part 1 example 1" do
    intcode = [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]

    intcode =
      IntcodeComputer.step(%State{intcode: intcode})
      |> Map.fetch!(:intcode)

    answer = Enum.at(intcode, 0)

    assert answer == 3500
    assert intcode == [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]
  end

  test "Day 2 Part 1 example 2" do
    intcode = [1, 0, 0, 0, 99]

    intcode =
      IntcodeComputer.step(%State{intcode: intcode})
      |> Map.fetch!(:intcode)

    answer = Enum.at(intcode, 0)

    assert answer == 2
    assert intcode == [2, 0, 0, 0, 99]
  end

  test "Day 2 Part 1 example 3" do
    intcode = [2, 4, 4, 5, 99, 0]

    intcode =
      IntcodeComputer.step(%State{intcode: intcode})
      |> Map.fetch!(:intcode)

    answer = Enum.at(intcode, 0)

    assert answer == 2
    assert intcode == [2, 4, 4, 5, 99, 9801]
  end

  test "Day 2 Part 1 example 4" do
    intcode = [1, 1, 1, 4, 99, 5, 6, 0, 99]

    intcode =
      IntcodeComputer.step(%State{intcode: intcode})
      |> Map.fetch!(:intcode)

    answer = Enum.at(intcode, 0)

    assert answer == 30
    assert intcode == [30, 1, 1, 4, 2, 5, 6, 0, 99]
  end
end
