defmodule Bob do
  import String
  import Kernel, except: [length: 1, match?: 2]
  def hey(input) do
    cond do
      is_empty?(input)          -> "Fine. Be that way!"
      is_shout_question?(input) -> "Calm down, I know what I'm doing!"
      is_shouting?(input)       -> "Whoa, chill out!"
      is_question?(input)       -> "Sure."
      true                      -> "Whatever."
    end
  end
  defp is_empty?(string) do
    contains?(string, "  ") or length(string) == 0
  end

  defp is_shout_question?(string) do
    match?(string, ~r/[[:alpha:]]/) and ends_with?(string, "?") and upcase(string) == string
  end

  defp is_shouting?(string) do
    upcase(string) == string and match?(string, ~r/[[:alpha:]]/)
  end

  defp is_question?(string) do
    ends_with?(string, "?")
  end
end
