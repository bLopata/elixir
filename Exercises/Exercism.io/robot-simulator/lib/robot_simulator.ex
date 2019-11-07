defmodule RobotSimulator do
  @directions [:north, :east, :south, :west]
  @right_turns %{
    north: :east,
    east: :south,
    south: :west,
    west: :north
    }
  @left_turns %{
    north: :west,
    east: :north,
    south: :east,
    west: :south
    }

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0}) do
    with :ok <- validate_pos(position),
         :ok <- validate_dir(direction),
    do: %{position: position, direction: direction}
  end

  defp validate_dir(dir) when dir in @directions, do: :ok
  defp validate_dir(_), do: {:error, "invalid direction"}
  defp validate_pos({x, y}) when is_integer(x) and is_integer(y), do: :ok
  defp validate_pos(_), do: {:error, "invalid position"}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot), do: robot.position

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    handle = fn
      "R", robot -> %{robot | direction: Map.fetch!(@right_turns, robot.direction)}
      "L", robot -> %{robot | direction: Map.fetch!(@left_turns, robot.direction)}
      "A", %{position: {x, y}, direction: :north} = robot -> %{robot | position: {x, y+1}}
      "A", %{position: {x, y}, direction: :east} = robot -> %{robot | position: {x+1, y}}
      "A", %{position: {x, y}, direction: :south} = robot -> %{robot | position:  {x, y-1}}
      "A", %{position: {x, y}, direction: :west} = robot -> %{robot | position: {x-1, y}}
      _, _ -> {:error, "invalid instruction"}
    end
    instructions |> String.graphemes |> Enum.reduce(robot, &handle.(&1, &2))
  end
end
