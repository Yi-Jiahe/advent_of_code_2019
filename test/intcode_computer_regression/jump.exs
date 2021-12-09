defmodule IntcodeComputerRegressionTest do
  alias Day9.IntcodeComputer
  alias Day9.IntcodeComputer.State

  use ExUnit.Case

  setup_all do
    {:ok,
     program_1: [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9],
     program_2: [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1],
     program_3: [
       3,
       21,
       1008,
       21,
       8,
       20,
       1005,
       20,
       22,
       107,
       8,
       21,
       20,
       1006,
       20,
       31,
       1106,
       0,
       36,
       98,
       0,
       0,
       1002,
       21,
       125,
       20,
       4,
       20,
       1105,
       1,
       46,
       104,
       999,
       1105,
       1,
       46,
       1101,
       1000,
       1,
       20,
       4,
       20,
       1105,
       1,
       46,
       98,
       99
     ]}
  end

  test "Part Two example 5: jump, position mode, input equals 0", state do
    input = 0
    intcode = state[:program_1]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 0
  end

  test "Part Two example 5: jump, position mode, input not equals 0", state do
    input = 3
    intcode = state[:program_1]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1
  end

  test "Part Two example 6: jump, immediate mode, input equals 0", state do
    input = 0
    intcode = state[:program_2]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 0
  end

  test "Part Two example 6: jump, immediate mode, input not equals 0", state do
    input = 3
    intcode = state[:program_2]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1
  end

  test "Part Two example 7, input less than 8", state do
    input = -3
    intcode = state[:program_3]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 999
  end

  test "Part Two example 7, input equals 8", state do
    input = 8
    intcode = state[:program_3]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1000
  end

  test "Part Two example 7, input more than 8", state do
    input = 99
    intcode = state[:program_3]

    output_buffer =
      IntcodeComputer.step(%State{intcode: intcode, input_buffer: [input]})
      |> Map.fetch!(:output_buffer)

    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1001
  end
end
