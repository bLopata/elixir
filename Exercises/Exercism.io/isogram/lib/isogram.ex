defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    char_count = String.downcase(sentence)
    |> String.replace(~r/[\s-]/, "")
    |> String.split("")
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, & &1+1) end)
    if((for c <- Map.keys(char_count), do: Map.fetch!(char_count, c)) > 0, do: false, else: true)
  end
end
