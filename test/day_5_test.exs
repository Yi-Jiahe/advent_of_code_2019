defmodule DayFiveTest do
  use ExUnit.Case

  test "Part One example 1" do
    input = 134123

    # The program 3,0,4,0,99 outputs whatever it gets as input, then halts.
    intcode = [3,0,4,0,99]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == input
  end

  test "Part One example 2" do
    intcode = [1002,4,3,4,33]
    {intcode, _, _} = DayFive.parse_intcode(0, intcode, [], [])
    assert intcode == [1002,4,3,4,99]
  end

  test "Part One example 3" do
    intcode = [1101,100,-1,4,0]
    {intcode, _, _} = DayFive.parse_intcode(0, intcode, [], [])
    assert intcode == [1101,100,-1,4,99]
  end

  test "Part Two example 1: equals, position mode, input equal to 8" do
    input = 8

    intcode = [3,9,8,9,10,9,4,9,99,-1,8]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1
  end

  test "Part Two example 1: equals, position mode, input not equal to 8" do
    input = -12

    intcode = [3,9,8,9,10,9,4,9,99,-1,8]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 0
  end

  test "Part Two example 2: less than, position mode, input less than 8" do
    input = -12

    intcode = [3,9,7,9,10,9,4,9,99,-1,8]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1
  end

  test "Part Two example 2: less than, position mode, input more than 8" do
    input = 20

    intcode = [3,9,7,9,10,9,4,9,99,-1,8]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 0
  end

  test "Part Two example 3: equals, immediate mode, input equal to 8" do
    input = 8

    intcode = [3,3,1108,-1,8,3,4,3,99]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1
  end

  test "Part Two example 3: equals, immediate mode, input not equal to 8" do
    input = -12

    intcode = [3,3,1108,-1,8,3,4,3,99]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 0
  end

  test "Part Two example 4: less than, immediate mode, input less than 8" do
    input = -12

    intcode = [3,3,1107,-1,8,3,4,3,99]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1
  end

  test "Part Two example 4: less than, immediate mode, input more than 8" do
    input = 20

    intcode = [3,3,1107,-1,8,3,4,3,99]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 0
  end

  test "Part Two example 5: jump, position mode, input equals 0" do
    input = 0

    intcode = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 0
  end

  test "Part Two example 5: jump, position mode, input not equals 0" do
    input = 3

    intcode = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1
  end

  test "Part Two example 6: jump, immediate mode, input equals 0" do
    input = 0

    intcode = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 0
  end

  test "Part Two example 6: jump, immediate mode, input not equals 0" do
    input = 3

    intcode = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1
  end

  test "Part Two example 7, input less than 8" do
    input = -3

    intcode = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
    1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
    999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 999
  end

  test "Part Two example 7, input equals 8" do
    input = 8

    intcode = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
    1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
    999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1000
  end

  test "Part Two example 7, input more than 8" do
    input = 99

    intcode = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
    1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
    999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
    {_, _, output_buffer} = DayFive.parse_intcode(0, intcode, [input], [])
    assert Enum.count(output_buffer) == 1
    assert Enum.at(output_buffer, 0) == 1001
  end
end
