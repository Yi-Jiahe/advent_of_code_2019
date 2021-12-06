defmodule DayOne do
  defmodule PartOne do
    def calculate_fuel_for_module(module_mass) do
      floor(module_mass / 3) - 2
    end
  end

  defmodule PartTwo do
    def calculate_fuel_for_module(module_mass) do
      extra_fuel_mass = floor(module_mass / 3) - 2
      calculate_fuel_for_mass(extra_fuel_mass, extra_fuel_mass)
    end

    def calculate_fuel_for_mass(total_fuel_mass, extra_fuel_mass) when extra_fuel_mass > 0 do
      extra_fuel_mass = floor(extra_fuel_mass / 3) - 2
      if extra_fuel_mass <= 0 do
        calculate_fuel_for_mass(total_fuel_mass, 0)
      else
        calculate_fuel_for_mass(total_fuel_mass + extra_fuel_mass, extra_fuel_mass)
      end
    end

    def calculate_fuel_for_mass(total_fuel_mass, extra_fuel_mass) when extra_fuel_mass <= 0 do
      total_fuel_mass
    end
  end

  def main(filename \\ "./puzzle_inputs/day_1/module_masses.txt") do
  case File.read(filename) do
    {:ok, body} ->
      module_masses = body
      |> String.split
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn {mass, _} -> mass end)

      part_one_sum = module_masses
      |> Enum.map(&PartOne.calculate_fuel_for_module/1)
      |> Enum.sum
      IO.puts("The sum of the fuel requirements for all the modules on the spacecraft is #{part_one_sum}.")

      part_two_sum = module_masses
      |> Enum.map((&PartTwo.calculate_fuel_for_module/1))
      |> Enum.sum
      IO.puts("The sum of the fuel requirements for all the modules on the spacecraft, taking into account the mass of the added fuel is #{part_two_sum}.")
    {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end

end
