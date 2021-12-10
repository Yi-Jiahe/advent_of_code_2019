defmodule Day10 do
  def get_asteriods(input) do
    input
    |> Utils.split_lines()
    |> Enum.with_index()
    |> Enum.map(&get_astroid_position(&1))
    |> List.flatten()
    |> Enum.filter(&(!is_nil(&1)))
  end

  def get_astroid_position(line) do
    {line, y} = line
    line = to_charlist(line)

    for {space, x} <- Enum.with_index(line) do
      if <<space>> == "#" do
        {x, y}
      end
    end
  end

  def gcd(x, 0), do: x
  def gcd(x, y), do: gcd(y, rem(x, y))

  def get_direction(asteroid, other_asteroid) do
    {x, y} = asteroid
    {x_other, y_other} = other_asteroid
    {x_diff, y_diff} = {x_other - x, y_other - y}

    d = gcd(abs(x_diff), abs(y_diff))
    {div(x_diff, d), div(y_diff, d)}
  end

  def count_directions_with_astroids(asteroid, asteroids, directions) do
    if Enum.empty?(asteroids) do
      {asteroid, directions}
    else
      {other_asteroid, asteroids} = List.pop_at(asteroids, 0)

      direction = get_direction(asteroid, other_asteroid)

      directions = MapSet.put(directions, direction)

      count_directions_with_astroids(asteroid, asteroids, directions)
    end
  end

  def determine_best_asteroid(asteroids) do
    asteroids
    |> Enum.with_index()
    |> Enum.map(fn {_astroid, i} -> List.pop_at(asteroids, i) end)
    |> Enum.map(fn {asteroid, other_astroids} ->
      count_directions_with_astroids(asteroid, other_astroids, MapSet.new())
    end)
    |> Enum.max_by(fn {_asteroid, directions} -> MapSet.size(directions) end)
  end

  def get_thetha(direction) do
    {x, y} = direction
    thetha = :math.atan2(x, -y)
    if thetha < 0, do: thetha + 2 * :math.pi(), else: thetha
  end

  def get_nth_destroyed_asteroid(station, directions, asteroids, n) do
    # This function only works for the first round
    direction_n =
      directions
      |> Enum.sort_by(&get_thetha(&1))
      |> Enum.at(n - 1)

    get_first_asteroid_in_direction(station, direction_n, asteroids)
  end

  def get_first_asteroid_in_direction(position, direction, asteroids) do
    {x, y} = position
    {grad_x, grad_y} = direction
    position = {x + grad_x, y + grad_y}

    if MapSet.member?(asteroids, position) do
      position
    else
      get_first_asteroid_in_direction(position, direction, asteroids)
    end
  end

  def determine_answer(asteroid) do
    {x, y} = asteroid
    x * 100 + y
  end

  def main(filename \\ "./puzzle_inputs/day_10/map.txt") do
    case File.read(filename) do
      {:ok, body} ->
        asteroids = get_asteriods(body)

        {asteroid, directions} = determine_best_asteroid(asteroids)
        max_astroids_seen = MapSet.size(directions)

        IO.puts(
          "The maximum number of asteroids visible from an asteroid is #{max_astroids_seen}"
        )

        asteroid = get_nth_destroyed_asteroid(asteroid, directions, MapSet.new(asteroids), 200)
        answer = determine_answer(asteroid)

        IO.puts("Answer: #{answer}")

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
