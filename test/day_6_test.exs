defmodule DaySixTest do
  use ExUnit.Case

  test "Part One example 1" do
    input = "COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L"

    orbits = DaySix.parse_input(input)
    tree = DaySix.grow_tree(orbits, Map.new())
    answer = DaySix.count_orbits(tree, "COM", 0, 0)
    assert answer == 42
  end

  test "Part Two example 1" do
    input = "COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    K)YOU
    I)SAN"

    orbits = DaySix.parse_input(input)
    tree = DaySix.grow_tree(orbits, Map.new())
    path_you = DaySix.find_path_to_child(tree, "COM", "YOU", [])
    path_santa = DaySix.find_path_to_child(tree, "COM", "SAN", [])
    assert path_you == ["COM", "B", "C", "D", "E", "J", "K"]
    assert path_santa == ["COM", "B", "C", "D", "I"]

    orbital_transfers = DaySix.count_orbital_transfers(path_you, path_santa)
    assert orbital_transfers == 4
  end
end
