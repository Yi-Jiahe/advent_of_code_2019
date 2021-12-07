defmodule DaySix do
  def parse_input(input) do
    input
    |> Utils.split_lines()
    |> Enum.map(&String.split(&1, ")"))
  end

  def grow_tree(orbits, tree) do
    if Enum.empty?(orbits) do
      tree
    else
      {[parent, child], orbits} = List.pop_at(orbits, 0)
      tree = Map.put_new(tree, parent, [])
      {_, tree} = Map.get_and_update(tree, parent, fn children -> {children, List.insert_at(children, -1, child)} end)
      grow_tree(orbits, tree)
    end
  end

  def count_orbits(tree, node, total, depth) do
    children = Map.get(tree, node)

    if is_nil(children) do
      depth
    else
      children_total = children
      |> Enum.map(&count_orbits(tree, &1, total, depth+1))
      |> Enum.sum()
      children_total + depth
    end
  end

  def find_path_to_child(_, node, child, path) when node == child do
      path
  end

  def find_path_to_child(tree, node, child, path) do
    path = List.insert_at(path, -1, node)

    children = Map.get(tree, node)

    if !is_nil(children) do
      children
      |> Enum.map(&find_path_to_child(tree, &1, child, path))
      |> Enum.filter(&!is_nil(&1))
      |> Enum.at(0)
    end
  end

  def count_orbital_transfers(path_you, path_santa) do
    path_you = MapSet.new(path_you)
    path_santa = MapSet.new(path_santa)

    common_root = MapSet.intersection(path_you, path_santa)

    leg_you = MapSet.difference(path_you, common_root)
    |> MapSet.to_list()
    |> Enum.count()
    leg_santa = MapSet.difference(path_santa, common_root)
    |> MapSet.to_list()
    |> Enum.count()

    leg_you - 1 + 1 + leg_santa
  end

  def main(filename \\ "./puzzle_inputs/day_6/local_orbits.txt") do
    case File.read(filename) do
      {:ok, body} ->
        orbits = parse_input(body)

        tree = grow_tree(orbits, Map.new())

        total_orbits = count_orbits(tree, "COM", 0, 0)
        IO.puts("There are #{total_orbits} total orbits")

        path_you = DaySix.find_path_to_child(tree, "COM", "YOU", [])
        path_santa = DaySix.find_path_to_child(tree, "COM", "SAN", [])
        orbital_transfers = count_orbital_transfers(path_you, path_santa)

        IO.puts("The minimum number of orbital transfers to get to santa is #{orbital_transfers}.")

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
