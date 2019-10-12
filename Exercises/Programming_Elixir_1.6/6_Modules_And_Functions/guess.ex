defmodule Chop do
  def guess(actual, _range = low..high) when actual in low..high == :false, do: IO.puts "play by the rules"
  def guess(actual, range = low..high) do
    current = div(low+high, 2)
    IO.puts "Is it #{current}"
    _guess(actual, current, range)
  end

  defp _guess(actual, actual, _) do
    IO.puts "Yes, it is #{actual}"
  end

  defp _guess(actual, guess, _low..high) when guess < actual, do: guess(actual, guess+1..high)

  defp _guess(actual, guess, low.._high) when guess > actual, do: guess(actual, low..guess-1)
end
