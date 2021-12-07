defmodule DayThree do
  def find_manhattan_distance_of_closest_intersection(intersections) do
    {point, intersections} = List.pop_at(intersections, 0)
    distance = manhattan_distance_from_origin(point)
    if Enum.empty?(intersections) do
      distance
    else
      find_manhattan_distance_of_closest_intersection(intersections, distance)
    end
  end

  def find_manhattan_distance_of_closest_intersection(intersections, shortest_distance) do
    {point, intersections} = List.pop_at(intersections, 0)
    distance = manhattan_distance_from_origin(point)
    shortest_distance = min(distance, shortest_distance)
    if Enum.empty?(intersections) do
      shortest_distance
    else
      find_manhattan_distance_of_closest_intersection(intersections, shortest_distance)
    end
  end

  def manhattan_distance_from_origin(point) do
    {x, y} = {Enum.at(point, 0), Enum.at(point, 1)}
    abs(x) + abs(y)
  end

  def move(point, points, index, direction, start_value, end_value) do
    new_value = start_value + direction
    point = List.replace_at(point, index, new_value)
    # IO.inspect(point, charlists: :as_lists)
    if new_value == end_value do
      {point, points}
    else
      move(point, List.insert_at(points, -1, point), index, direction, new_value, end_value)
    end
  end

  def move_segment(point, points, segment) do
    {direction, x} = String.split_at(segment, 1)
    {x, _} = Integer.parse(x)

    case direction do
      "U" ->
        # IO.puts("Up #{x}")
        current_y = Enum.at(point, 1)
        move(point, points, 1, 1, current_y, current_y + x)
      "D" ->
        # IO.puts("Down #{x}")
        current_y = Enum.at(point, 1)
        move(point, points, 1, -1, current_y, current_y - x)
      "L" ->
        # IO.puts("Left #{x}")
        current_x = Enum.at(point, 0)
        move(point, points, 0, -1, current_x, current_x - x)
      "R" ->
        # IO.puts("Right #{x}")
        current_x = Enum.at(point, 0)
        move(point, points, 0, 1, current_x, current_x + x)
    end
  end

  def move_path(path, point, points) do
    {segment, path} = List.pop_at(path, 0)
    {point, points_new} = move_segment(point, points, segment)
    points = Enum.concat(points, points_new)
    if Enum.empty?(path) do
      points
    else
      move_path(path, point, Enum.concat(points, points_new))
    end
  end

  def find_wire_points(path) do
    points = MapSet.new(move_path(path, [0, 0], []))
    points
  end

  def parse_input(input) do
    paths = Utils.split_lines(input)
    |> Enum.map(&String.split(&1, ",", trim: true))
    paths
  end

  def find_intersections(paths) do
    [points_1, points_2] = paths
    MapSet.to_list(MapSet.intersection(points_1, points_2))
  end

  def main(filename \\ "./puzzle_inputs/day_3/paths.txt") do
    case File.read(filename) do
      {:ok, body} ->
        paths = parse_input(body)
        paths = paths
        |> Enum.map(&find_wire_points/1)
        intersections = find_intersections(paths)
        answer = find_manhattan_distance_of_closest_intersection(intersections)
        IO.puts(answer)
      {:error, reason} -> IO.puts("Error: #{reason}")
    end

  end
end
