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


ExUnit.start()
defmodule RobotSimulatorTest do
  use ExUnit.Case

  test "create has sensible defaults" do
    robot = RobotSimulator.create()
    assert RobotSimulator.position(robot) == {0, 0}
    assert RobotSimulator.direction(robot) == :north
  end

  @tag :pending
  test "create works with valid arguments" do
    robot = RobotSimulator.create(:north, {0, 0})
    assert RobotSimulator.position(robot) == {0, 0}
    assert RobotSimulator.direction(robot) == :north

    robot = RobotSimulator.create(:south, {-10, 0})
    assert RobotSimulator.position(robot) == {-10, 0}
    assert RobotSimulator.direction(robot) == :south

    robot = RobotSimulator.create(:east, {0, 10})
    assert RobotSimulator.position(robot) == {0, 10}
    assert RobotSimulator.direction(robot) == :east

    robot = RobotSimulator.create(:west, {100, -100})
    assert RobotSimulator.position(robot) == {100, -100}
    assert RobotSimulator.direction(robot) == :west
  end

  @tag :pending
  test "create errors if invalid direction given" do
    position = {0, 0}
    invalid_direction = {:error, "invalid direction"}

    assert RobotSimulator.create(:invalid, position) == invalid_direction
    assert RobotSimulator.create(0, position) == invalid_direction
    assert RobotSimulator.create("east", position) == invalid_direction
  end

  @tag :pending
  test "create errors if invalid position given" do
    direction = :north
    invalid_position = {:error, "invalid position"}

    assert RobotSimulator.create(direction, {0, 0, 0}) == invalid_position
    assert RobotSimulator.create(direction, {0, :invalid}) == invalid_position
    assert RobotSimulator.create(direction, {"0", 0}) == invalid_position

    assert RobotSimulator.create(direction, "invalid") == invalid_position
    assert RobotSimulator.create(direction, 0) == invalid_position
    assert RobotSimulator.create(direction, [0, 0]) == invalid_position
    assert RobotSimulator.create(direction, nil) == invalid_position
  end

  @tag :pending
  test "simulate robots" do
    robot1 = RobotSimulator.create(:north, {0, 0}) |> RobotSimulator.simulate("LAAARALA")
    assert RobotSimulator.direction(robot1) == :west
    assert RobotSimulator.position(robot1) == {-4, 1}

    robot2 = RobotSimulator.create(:east, {2, -7}) |> RobotSimulator.simulate("RRAAAAALA")
    assert RobotSimulator.direction(robot2) == :south
    assert RobotSimulator.position(robot2) == {-3, -8}

    robot3 = RobotSimulator.create(:south, {8, 4}) |> RobotSimulator.simulate("LAAARRRALLLL")
    assert RobotSimulator.direction(robot3) == :north
    assert RobotSimulator.position(robot3) == {11, 5}
  end

  @tag :pending
  test "simulate errors on invalid instructions" do
    assert RobotSimulator.create() |> RobotSimulator.simulate("UUDDLRLRBASTART") ==
             {:error, "invalid instruction"}
  end
end

