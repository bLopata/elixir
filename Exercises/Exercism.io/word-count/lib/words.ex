defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    words = String.downcase(sentence) |> String.split(" ", ", "]) |> String.replace()
    Enum.reduce(words, %{}, fn x, acc -> Map.update(acc, x, 1, & &1+1))
  end
end
