defmodule DayEightTest do
  use ExUnit.Case

  test "Parse Part One example image" do
    assert DayEight.parse_image_from_string("123456789012", {3, 2}) == [
             ["123", "456"],
             ["789", "012"]
           ]
  end
end
