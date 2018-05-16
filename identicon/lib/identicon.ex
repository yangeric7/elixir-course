defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  def main(input) do
    input
    |> hash_string
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map

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

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
     grid = Enum.filter grid, fn({code, _index}) -> #convention is that if you have a function inside a function, remove parens and then new line the function
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end
end
