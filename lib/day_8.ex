defmodule DayEight do
  def retrieve_layer(string, layer, layer_shape) do
    {width, height} = layer_shape
    layer_size = width * height

    for i <- 0..height-1 do
      for j <- 0..width-1, into: ""  do
        String.at(string, (layer-1) * layer_size + i * width + j)
      end
    end
  end

  def parse_image_from_string(input, layer_shape) do
    {width, height} = layer_shape
    layer_size = width * height

    for layer <- 1..trunc(String.length(input) / layer_size) do
      retrieve_layer(input, layer, layer_shape)
    end
  end

  def count_in_layer(layer, digit) do
    for row <- layer, << pixel <- row >> do
      if <<pixel>> == digit do
        1
      else
        0
      end
    end
    |> Enum.sum()
  end

  def merge_pixel(image, layer, i, layer_shape) do
    {width, height} = layer_shape
    layer_size = width * height

    if i == layer_size do
      image
    else
      {y, x} = {div(i, width), rem(i, width)}
      row = image
      |> Enum.at(y)
      image_pixel = row
      |> to_charlist()
      |> Enum.at(x)
      layer_pixel = layer
      |> Enum.at(y)
      |> to_charlist()
      |> Enum.at(x)
      case {<<image_pixel>>, <<layer_pixel>>} do
        {"2", p} ->
          new_row = row
          |> to_charlist()
          |> List.replace_at(x, p)
          |> to_string()
          image = image
          |> List.replace_at(y, new_row)
          merge_pixel(image, layer, i+1, layer_shape)
        {_, _} ->
          merge_pixel(image, layer, i+1, layer_shape)
      end
    end
  end

  def merge_layers(layers, image, layer_shape) do
    if Enum.empty?(layers) do
      image
    else
      {layer, layers} = List.pop_at(layers, 0)
      image = merge_pixel(image, layer, 0, layer_shape)
      merge_layers(layers, image, layer_shape)
    end
  end

  @spec main(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | char,
              binary | []
            )
        ) :: any
  def main(filename \\ "./puzzle_inputs/day_8/password.txt") do
    case File.read(filename) do
      {:ok, body} ->
        {width, height} = {25, 6}
        layers = parse_image_from_string(body, {width, height})

        layer = layers
        |> Enum.min_by(&count_in_layer(&1, "0"))

        ones = count_in_layer(layer, "1")
        twos = count_in_layer(layer, "2")
        answer = ones * twos
        IO.puts("Answer: #{answer}")

        image = String.duplicate("2", width)
        |> List.duplicate(height)
        merge_layers(layers, image, {width, height})
        |> Enum.each(&IO.inspect(&1))
        |> IO.inspect()
      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end

end
