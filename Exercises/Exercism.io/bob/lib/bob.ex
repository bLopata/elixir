defmodule Bob do
  def hey(input) do
    cond do
      String.capitalize(input) != input and String.ends_with?(input, "?") -> "Calm down, I know what I'm doing!"
      String.contains?(input, "  ") or String.length(input) == 0 -> "Fine. Be that way!"
      String.upcase(input) == input and String.match?(input, ~r/[[:alpha:]]/) -> "Whoa, chill out!"
      String.ends_with?(input, "?") -> "Sure."
      true -> "Whatever."
    end
  end
end
