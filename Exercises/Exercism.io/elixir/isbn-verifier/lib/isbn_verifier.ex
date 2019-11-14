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
    case Regex.match?(~r/^(\d-?){9}(X|\d)$/, isbn) do
      false -> false
      true -> String.replace(isbn, "-", "")
      |> String.split("", trim: true)
      |> Enum.zip(10..1)
      |> Enum.map(&calculate_isbn/1)
      |> Enum.sum
      |> rem(11) == 0
    end
  end

  defp calculate_isbn({"X", _}), do: 10
  defp calculate_isbn({val, mult}), do: String.to_integer(val) * mult
end
