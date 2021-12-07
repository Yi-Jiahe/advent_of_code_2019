defmodule DayFour do
  defmodule PartOne do
    def has_same_adjacent_digits(password) do
      char = String.at(password, 0)
      has_same_adjacent_digits(password, 1, char)
    end

    def has_same_adjacent_digits(password, i, last_digit) do
      char = String.at(password, i)

      if char == last_digit do
        true
      else
        i = i + 1

        if i == String.length(password) do
          false
        else
          has_same_adjacent_digits(password, i, char)
        end
      end
    end

    def criteria_met(password) do
      String.length(password) == 6 and has_same_adjacent_digits(password) and DayFour.never_decreases(password)
    end

    def count_matching_passwords(range) do
      [lower_bound, upper_bound] = range

      lower_bound..upper_bound
      |> Enum.count(fn x -> criteria_met(Integer.to_string(x)) end)
    end
  end

  def parse_input(input) do
    String.split(input, "-")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
  end

  def never_decreases(password) do
    {digit, _} =
      String.at(password, 0)
      |> Integer.parse

    never_decreases(password, 1, digit)
  end

  def never_decreases(password, i, last_digit) do
    {digit, _} =
      String.at(password, i)
      |> Integer.parse

    if digit < last_digit do
      false
    else
      i = i + 1

      if i == String.length(password) do
        true
      else
        never_decreases(password, i, digit)
      end
    end
  end

  def main do
    puzzle_input = "240298-784956"
    range = parse_input(puzzle_input)
    answer = PartOne.count_matching_passwords(range)
    IO.puts("#{answer} passwords meet the criteria.")
  end
end
