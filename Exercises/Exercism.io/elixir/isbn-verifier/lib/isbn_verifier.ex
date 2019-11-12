defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> ISBNVerifier.isbn?("3-598-21507-X")
      true

      iex> ISBNVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    with true <- isbn |> String.contains?(~r/[a-w]/), do: false
    parsed = String.replace(isbn, "-", "")
    |> String.replace("X", "10")
    |> String.split("", trim: true)

    sum = for char <- parsed, y <- 10..1, do: String.to_integer(char) * y
    Enum.sum(sum) |> rem(11) == 0
  end
end
