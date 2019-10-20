defmodule RotationalCipher do
  @lower ?a..?z
  @upper ?A..?Z

  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """

  # Anchor case
  def caesar([], _n), do: []
  # Handle space or number char
  def caesar([head | tail], n) when head < ?9, do: [head | caesar(tail, n)]
  # Handle upper case
  def caesar([head | tail], n) when head < ?a and head + n > ?Z,
    do: [head + n - 26 | caesar(tail, n)]

  # Handle lower case
  def caesar([head | tail], n) when head + n <= ?z, do: [head + n | caesar(tail, n)]
  # Handle text wrap
  def caesar([head | tail], n), do: [head + n - 26 | caesar(tail, n)]

  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    text |> to_charlist |> Enum.map(&encode_char(&1, shift)) |> to_string
  end

  defp encode_char(char, shift) do
    cond do
      char in @lower -> rem(char - ?a + shift, 26) + ?a
      char in @upper -> rem(char - ?A + shift, 26) + ?A
      true -> char
    end
  end
end
