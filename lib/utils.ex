defmodule Utils do
  def split_lines(input) do
    String.split(input, ~r{ *\r\n *| *\n *}, trim: true)
  end
end
