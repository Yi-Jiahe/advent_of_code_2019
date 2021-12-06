defmodule DayTwoTest do
  use ExUnit.Case

  test "compute example programs" do
    intcode = [1,9,10,3,2,3,11,0,99,30,40,50]
    {answer, intcode_result_part_one} = DayTwo.parse_intcode(0, intcode)
    assert answer == 3500
    assert intcode_result_part_one == [3500,9,10,70,2,3,11,0,99,30,40,50]

    intcode = [1,0,0,0,99]
    {answer, intcode_result_part_one} = DayTwo.parse_intcode(0, intcode)
    assert answer == 2
    assert intcode_result_part_one == [2,0,0,0,99]

    intcode = [2,4,4,5,99,0]
    {answer, intcode_result_part_one} = DayTwo.parse_intcode(0, intcode)
    assert answer == 2
    assert intcode_result_part_one == [2,4,4,5,99,9801]

    intcode = [1,1,1,4,99,5,6,0,99]
    {answer, intcode_result_part_one} = DayTwo.parse_intcode(0, intcode)
    assert answer == 30
    assert intcode_result_part_one == [30,1,1,4,2,5,6,0,99]
  end
end
