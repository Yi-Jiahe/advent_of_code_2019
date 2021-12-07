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
    end
  end
end
