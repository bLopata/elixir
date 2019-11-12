# pos = {:poop, 0}
# {x, y} = pos
# IO.inspect {is_integer(x), is_integer(y)}

# IO.inspect x
# IO.inspect y

# [{:north, :east, :west}, {:east, :south, :north}, {:south, :west, :east}, {:west, :north, :south}]

right_turns = %{
    north: :east,
    east: :south,
    south: :west,
    west: :north
}
left_turns = %{
    north: :west,
    east: :north,
    south: :east,
    west: :south
}
movement = %{
  north: fn {x, y} -> {x, y+1} end,
  east: fn {x, y} -> {x+1, y} end,
  south: fn {x, y} -> {x-1, y} end,
  west:  fn {x, y} -> {x, y-1} end,
}

      "A", %{position: {x, y}, direction: direction} = robot -> %{robot | position: apply(Map.fetch!(move, direction), [{x,y}])}

IO.inspect Map.fetch!(right_turns, :east)
{x, y} = {1, 2}
IO.inspect apply(Map.fetch!(movement, :east), [{x, y}])
