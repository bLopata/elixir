defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) do
    Enum.sort([a, b, c]) |> determine_type()
  end
  defp determine_type([a, _, _]) when a <= 0, do: {:error, "all side lengths must be positive"}
  defp determine_type([a, b, c]) when a + b <= c, do: {:error, "side lengths violate triangle inequality"}
  defp determine_type([a, b, c]) when a == b and b == c, do: {:ok, :equilateral}
  defp determine_type([a, b, c]) when a == b or b == c, do: {:ok, :isosceles}
  defp determine_type([a, b, c]) when a + b > c, do: {:ok, :scalene}
end
