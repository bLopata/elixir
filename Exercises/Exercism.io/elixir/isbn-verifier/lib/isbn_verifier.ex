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
    String.replace(isbn, "-", "")
    |> String.split("", trim: true)
    |> IO.inspect
    # |> valid?

  end

  defp valid?(char) when is_integer(char) do
    sum = for y <- 10..1, do: String.to_integer(char) * y
    Enum.sum(sum) |> rem(11) == 0
  end
  defp valid?(_), do: false
end
