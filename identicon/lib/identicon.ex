defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  def main(input) do
    input
    |> hash_string
    |> pick_color
    |> build_grid

  end

  def hash_string(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  # We can pattern match properties inside the argument to the function
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do

    #New Struct to hold in image, but also add into the struct the color
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3) # didn't see Enum.chunk(list, count) in docs so equivalent in v1.6.5 is Enum.chunk_every(list, count, count, :discard)
      |> Enum.map(&mirror_row/1) # passing in reference to function
      |> List.flatten
      |> Enum.with_index #this makes a list of tuples with {value, index}

    %Identicon.Image{image | grid: grid}

  end

  def mirror_row(row) do
    # [145, 46, 200]
    [first, second | _tail] = row

    # [145, 46, 200, 46, 145] (new operatoe ++ which appends two lists)
    row  ++ [second, first]
  end
end
