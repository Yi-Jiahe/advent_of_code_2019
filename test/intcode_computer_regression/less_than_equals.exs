defmodule IntcodeComputerRegressionTest do
  alias Day9.IntcodeComputer
  alias Day9.IntcodeComputer.State

  use ExUnit.Case

  setup_all do
    {:ok,
     program_1: [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8],
     program_2: [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8],
     program_3: [3, 3, 1108, -1, 8, 3, 4, 3, 99],
     program_4: [3, 3, 1107, -1, 8, 3, 4, 3, 99]}
  end

  test "Equals, position mode, input equal to 8", state do
    input = 8
    intcode = state[:program_1]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1
  end

  test "Equals, position mode, input not equal to 8", state do
    input = -12
    intcode = state[:program_1]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 0
  end

  test "Less than, position mode, input less than 8", state do
    input = -12
    intcode = state[:program_2]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1
  end

  test "Less than, position mode, input more than 8", state do
    input = 20
    intcode = state[:program_2]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 0
  end

  test "Equals, immediate mode, input equal to 8", state do
    input = 8
    intcode = state[:program_3]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1
  end

  test "Equals, immediate mode, input not equal to 8", state do
    input = -12
    intcode = state[:program_3]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 0
  end

  test "Less than, immediate mode, input less than 8", state do
    input = -12
    intcode = state[:program_4]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1
  end

  test "Less than, immediate mode, input more than 8", state do
    input = 20
    intcode = state[:program_4]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 0
  end
end
