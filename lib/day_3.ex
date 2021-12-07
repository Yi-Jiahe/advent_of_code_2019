defmodule DayThree do
  defmodule PartOne do
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

    def update_intersections(point, path_1_points, intersections) do
      if MapSet.member?(path_1_points, point) do
        MapSet.put(intersections, point)
      else
        intersections
      end
    end

    @doc """
    Moves the first wire along the segment, adding to the wire points as it goes.
    """
    def move(point, points, index, direction, start_value, end_value) do
      new_value = start_value + direction
      point = List.replace_at(point, index, new_value)

      if new_value == end_value do
        {point, points}
      else
        move(point, MapSet.put(points, point), index, direction, new_value, end_value)
      end
    end

    @doc """
    Moves the second wire along each segment, returning any intersections with the first wire's path.
    """
    def move(point, path_1_points, index, direction, start_value, end_value, intersections) do
      new_value = start_value + direction
      point = List.replace_at(point, index, new_value)
      intersections = update_intersections(point, path_1_points, intersections)

      if new_value == end_value do
        {point, intersections}
      else
        move(point, path_1_points, index, direction, new_value, end_value, intersections)
      end
    end

    @doc """
    Moves the first wire along its path, returning the points on each segment.
    """
    def move_segment(point, segment) do
      {direction, x} = String.split_at(segment, 1)
      {x, _} = Integer.parse(x)

      case direction do
        "U" ->
          # IO.puts("Up #{x}")
          current_y = Enum.at(point, 1)
          move(point, MapSet.new(), 1, 1, current_y, current_y + x)

        "D" ->
          # IO.puts("Down #{x}")
          current_y = Enum.at(point, 1)
          move(point, MapSet.new(), 1, -1, current_y, current_y - x)

        "L" ->
          # IO.puts("Left #{x}")
          current_x = Enum.at(point, 0)
          move(point, MapSet.new(), 0, -1, current_x, current_x - x)

        "R" ->
          # IO.puts("Right #{x}")
          current_x = Enum.at(point, 0)
          move(point, MapSet.new(), 0, 1, current_x, current_x + x)
      end
    end

    @doc """
    Moves the second wire along its path, returning any intersections with the first wire's path along the segment.
    """
    def move_segment(point, path_1_points, segment) do
      {direction, x} = String.split_at(segment, 1)
      {x, _} = Integer.parse(x)

      case direction do
        "U" ->
          # IO.puts("Up #{x}")
          current_y = Enum.at(point, 1)
          move(point, path_1_points, 1, 1, current_y, current_y + x, MapSet.new())

        "D" ->
          # IO.puts("Down #{x}")
          current_y = Enum.at(point, 1)
          move(point, path_1_points, 1, -1, current_y, current_y - x, MapSet.new())

        "L" ->
          # IO.puts("Left #{x}")
          current_x = Enum.at(point, 0)
          move(point, path_1_points, 0, -1, current_x, current_x - x, MapSet.new())

        "R" ->
          # IO.puts("Right #{x}")
          current_x = Enum.at(point, 0)
          move(point, path_1_points, 0, 1, current_x, current_x + x, MapSet.new())
      end
    end

    @doc """
    Moves the first wire along its path, returning the points along the path.
    """
    def move_path(path, point, points) do
      {segment, path} = List.pop_at(path, 0)
      {point, points_new} = move_segment(point, segment)
      points = MapSet.union(points, points_new)

      if Enum.empty?(path) do
        points
      else
        move_path(path, point, points)
      end
    end

    @doc """
    Moves the second wire along its path, returning all intersections with the first
    """
    def move_path(path, point, path_1_points, intersections) do
      {segment, path} = List.pop_at(path, 0)
      {point, intersections_new} = move_segment(point, path_1_points, segment)
      intersections = MapSet.union(intersections, intersections_new)

      if Enum.empty?(path) do
        intersections
      else
        move_path(path, point, path_1_points, intersections)
      end
    end

    @doc """
    Find a MapSet of points along the first wire's path
    """
    def find_wire_points(path) do
      move_path(path, [0, 0], MapSet.new())
    end

    def find_intersections(paths) do
      [path_1, path_2] = paths
      path_1_points = find_wire_points(path_1)
      intersections = move_path(path_2, [0, 0], path_1_points, MapSet.new())
      MapSet.to_list(intersections)
    end
  end

  defmodule PartTwo do
    def update_intersections(point, path_1_points, intersections, steps) do
      if Map.has_key?(path_1_points, point) do
        total_steps = steps + Map.get(path_1_points, point)

        if Map.has_key?(intersections, point) do
          if total_steps >= Map.get(intersections, point) do
            intersections
          else
            Map.replace(intersections, point, total_steps)
          end
        else
          Map.put(intersections, point, total_steps)
        end
      else
        intersections
      end
    end

    @doc """
    Moves the first wire along the segment, adding to the wire points as it goes.
    """
    def move(point, points, index, direction, start_value, end_value, steps) do
      new_value = start_value + direction
      point = List.replace_at(point, index, new_value)
      new_steps = steps + 1

      if new_value == end_value do
        {point, points, new_steps}
      else
        move(
          point,
          Map.put_new(points, point, new_steps),
          index,
          direction,
          new_value,
          end_value,
          new_steps
        )
      end
    end

    @doc """
    Moves the second wire along each segment, returning any intersections with the first wire's path.
    """
    def move(point, path_1_points, index, direction, start_value, end_value, intersections, steps) do
      new_value = start_value + direction
      point = List.replace_at(point, index, new_value)
      new_steps = steps + 1
      intersections = update_intersections(point, path_1_points, intersections, new_steps)

      if new_value == end_value do
        {point, intersections, new_steps}
      else
        move(
          point,
          path_1_points,
          index,
          direction,
          new_value,
          end_value,
          intersections,
          new_steps
        )
      end
    end

    @doc """
    Moves the first wire along its path, returning the points on each segment.
    """
    def move_segment(point, segment, steps) do
      {direction, x} = String.split_at(segment, 1)
      {x, _} = Integer.parse(x)

      case direction do
        "U" ->
          # IO.puts("Up #{x}")
          current_y = Enum.at(point, 1)
          move(point, Map.new(), 1, 1, current_y, current_y + x, steps)

        "D" ->
          # IO.puts("Down #{x}")
          current_y = Enum.at(point, 1)
          move(point, Map.new(), 1, -1, current_y, current_y - x, steps)

        "L" ->
          # IO.puts("Left #{x}")
          current_x = Enum.at(point, 0)
          move(point, Map.new(), 0, -1, current_x, current_x - x, steps)

        "R" ->
          # IO.puts("Right #{x}")
          current_x = Enum.at(point, 0)
          move(point, Map.new(), 0, 1, current_x, current_x + x, steps)
      end
    end

    @doc """
    Moves the second wire along its path, returning any intersections with the first wire's path along the segment.
    """
    def move_segment(point, path_1_points, segment, steps) do
      {direction, x} = String.split_at(segment, 1)
      {x, _} = Integer.parse(x)

      case direction do
        "U" ->
          # IO.puts("Up #{x}")
          current_y = Enum.at(point, 1)
          move(point, path_1_points, 1, 1, current_y, current_y + x, Map.new(), steps)

        "D" ->
          # IO.puts("Down #{x}")
          current_y = Enum.at(point, 1)
          move(point, path_1_points, 1, -1, current_y, current_y - x, Map.new(), steps)

        "L" ->
          # IO.puts("Left #{x}")
          current_x = Enum.at(point, 0)
          move(point, path_1_points, 0, -1, current_x, current_x - x, Map.new(), steps)

        "R" ->
          # IO.puts("Right #{x}")
          current_x = Enum.at(point, 0)
          move(point, path_1_points, 0, 1, current_x, current_x + x, Map.new(), steps)
      end
    end

    @doc """
    Moves the first wire along its path, returning the points along the path.
    """
    def move_path(path, point, points, steps) do
      {segment, path} = List.pop_at(path, 0)
      {point, points_new, steps_new} = move_segment(point, segment, steps)
      points = Map.merge(points_new, points)

      if Enum.empty?(path) do
        points
      else
        move_path(path, point, points, steps_new)
      end
    end

    @doc """
    Moves the second wire along its path, returning all intersections with the first
    """
    def move_path(path, point, path_1_points, intersections, steps) do
      {segment, path} = List.pop_at(path, 0)
      {point, intersections_new, new_steps} = move_segment(point, path_1_points, segment, steps)
      intersections = Map.merge(intersections, intersections_new, fn _, v1, v2 -> min(v1, v2) end)

      if Enum.empty?(path) do
        intersections
      else
        move_path(path, point, path_1_points, intersections, new_steps)
      end
    end

    @doc """
    Find a MapSet of points along the first wire's path
    """
    def find_wire_points(path) do
      move_path(path, [0, 0], Map.new(), 0)
    end

    def find_intersections(paths) do
      [path_1, path_2] = paths
      path_1_points = find_wire_points(path_1)
      move_path(path_2, [0, 0], path_1_points, Map.new(), 0)
    end
  end

  def parse_input(input) do
    paths =
      Utils.split_lines(input)
      |> Enum.map(&String.split(&1, ",", trim: true))

    paths
  end

  def part_one(paths) do
    intersections = PartOne.find_intersections(paths)
    PartOne.find_manhattan_distance_of_closest_intersection(intersections)
  end

  def part_two(paths) do
    PartTwo.find_intersections(paths)
    |> Enum.min_by(fn {_, v} -> v end)
    |> elem(1)
  end

  def main(filename \\ "./puzzle_inputs/day_3/paths.txt") do
    case File.read(filename) do
      {:ok, body} ->
        paths = parse_input(body)

        answer = part_one(paths)
        IO.puts("The Manhattan distance from the central port to the closest intersection is #{answer}")

        answer = part_two(paths)
        IO.puts("The fewest combined steps toan intersection is #{answer}")

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
