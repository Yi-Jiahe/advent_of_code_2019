defmodule AOC_2019 do
  @moduledoc """
  Documentation for `AOC_2019`.
  """

  def main(day) do
    case day do
      1 ->
        DayOne.main()
      2 ->
        DayTwo.main()
      3 ->
        DayThree.main()
      4 ->
        DayFour.main()
      5 ->
        DayFive.main()
      6 ->
        DaySix.main()
      7 ->
        DaySeven.main()
      8 ->
        DayEight.main()
    end
  end
end
