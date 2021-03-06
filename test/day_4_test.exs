defmodule DayFourTest do
  use ExUnit.Case

  test "Part One example 1" do
    password = "111111"
    assert DayFour.PartOne.has_same_adjacent_digits(password) == true
    assert DayFour.never_decreases(password) == true
    assert DayFour.PartOne.criteria_met(password) == true
  end

  test "Part One example 2" do
    password = "223450"
    assert DayFour.PartOne.has_same_adjacent_digits(password) == true
    assert DayFour.never_decreases(password) == false
    assert DayFour.PartOne.criteria_met(password) == false
  end

  test "Part One example 3" do
    password = "123789"
    assert DayFour.PartOne.has_same_adjacent_digits(password) == false
    assert DayFour.never_decreases(password) == true
    assert DayFour.PartOne.criteria_met(password) == false
  end

  test "Part Two example 1" do
    password = "112233"
    assert DayFour.PartTwo.has_group_of_two(password) == true
    assert DayFour.never_decreases(password) == true
    assert DayFour.PartTwo.criteria_met(password) == true
  end

  test "Part Two example 2" do
    password = "123444"
    assert DayFour.PartTwo.has_group_of_two(password) == false
    assert DayFour.never_decreases(password) == true
    assert DayFour.PartTwo.criteria_met(password) == false
  end

  test "Part Two example 3" do
    password = "111122"
    assert DayFour.PartTwo.has_group_of_two(password) == true
    assert DayFour.never_decreases(password) == true
    assert DayFour.PartTwo.criteria_met(password) == true
  end
end
