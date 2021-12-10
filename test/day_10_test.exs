defmodule Day10Test do
  use ExUnit.Case

  test "Example 1" do
    map = ".#..#
    .....
    #####
    ....#
    ...##"

    asteroids = Day10.get_asteriods(map)
    {asteroid, directions} = Day10.determine_best_asteroid(asteroids)
    max_astroids_seen = MapSet.size(directions)
    assert max_astroids_seen == 8
    assert asteroid == {3, 4}
  end

  test "Example 2" do
    map = "......#.#.
    #..#.#....
    ..#######.
    .#.#.###..
    .#..#.....
    ..#....#.#
    #..#....#.
    .##.#..###
    ##...#..#.
    .#....####"

    asteroids = Day10.get_asteriods(map)
    {asteroid, directions} = Day10.determine_best_asteroid(asteroids)
    max_astroids_seen = MapSet.size(directions)
    assert max_astroids_seen == 33
    assert asteroid == {5, 8}
  end

  test "Example 3" do
    map = "#.#...#.#.
    .###....#.
    .#....#...
    ##.#.#.#.#
    ....#.#.#.
    .##..###.#
    ..#...##..
    ..##....##
    ......#...
    .####.###."

    asteroids = Day10.get_asteriods(map)
    {asteroid, directions} = Day10.determine_best_asteroid(asteroids)
    max_astroids_seen = MapSet.size(directions)
    assert max_astroids_seen == 35
    assert asteroid == {1, 2}
  end

  test "Example 4" do
    map = ".#..#..###
    ####.###.#
    ....###.#.
    ..###.##.#
    ##.##.#.#.
    ....###..#
    ..#.#..#.#
    #..#.#.###
    .##...##.#
    .....#.#.."

    asteroids = Day10.get_asteriods(map)
    {asteroid, directions} = Day10.determine_best_asteroid(asteroids)
    max_astroids_seen = MapSet.size(directions)
    assert max_astroids_seen == 41
    assert asteroid == {6, 3}
  end

  test "Example 5" do
    map = ".#..##.###...#######
    ##.############..##.
    .#.######.########.#
    .###.#######.####.#.
    #####.##.#.##.###.##
    ..#####..#.#########
    ####################
    #.####....###.#.#.##
    ##.#################
    #####.##.###..####..
    ..######..##.#######
    ####.##.####...##..#
    .#####..#.######.###
    ##...#.##########...
    #.##########.#######
    .####.#.###.###.#.##
    ....##.##.###..#####
    .#.#.###########.###
    #.#.#.#####.####.###
    ###.##.####.##.#..##"

    asteroids = Day10.get_asteriods(map)
    {asteroid, directions} = Day10.determine_best_asteroid(asteroids)
    max_astroids_seen = MapSet.size(directions)
    assert max_astroids_seen == 210
    assert asteroid == {11, 13}

    asteroid = Day10.get_nth_destroyed_asteroid(asteroid, directions, MapSet.new(asteroids), 200)

    assert asteroid == {8, 2}
    assert Day10.determine_answer(asteroid) == 802
  end
end
