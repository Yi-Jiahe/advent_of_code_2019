defmodule DayThreeTest do
  use ExUnit.Case

  test "Part One example 1" do
    paths = "R8,U5,L5,D3
    U7,R6,D4,L4"
    paths = DayThree.parse_input(paths)
    answer = DayThree.part_one(paths)
    assert answer == 6
  end

  test "Part One example 2" do
    paths = "R75,D30,R83,U83,L12,D49,R71,U7,L72
    U62,R66,U55,R34,D71,R55,D58,R83"
    paths = DayThree.parse_input(paths)
    answer = DayThree.part_one(paths)
    assert answer == 159
  end

  test "Part One example 3" do
    paths = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
    U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    paths = DayThree.parse_input(paths)
    answer = DayThree.part_one(paths)
    assert answer == 135
  end
end
