defmodule DayOneTest do
  use ExUnit.Case

  test "part one" do
    assert DayOne.PartOne.calculate_fuel_for_module(12) == 2
    assert DayOne.PartOne.calculate_fuel_for_module(14) == 2
    assert DayOne.PartOne.calculate_fuel_for_module(1969) == 654
    assert DayOne.PartOne.calculate_fuel_for_module(100756) == 33583
  end

  test "part two" do
    assert DayOne.PartTwo.calculate_fuel_for_module(14) == 2
    assert DayOne.PartTwo.calculate_fuel_for_module(1969) == 966
    assert DayOne.PartTwo.calculate_fuel_for_module(100756) == 50346
  end
end
