defmodule Utils do
  def split_lines(input) do
    String.split(input, ~r{ *\r\n *| *\n *}, trim: true)
  end

  def print_int_list(int_list) do
    IO.inspect(int_list, charlists: :as_lists)
  end
end
