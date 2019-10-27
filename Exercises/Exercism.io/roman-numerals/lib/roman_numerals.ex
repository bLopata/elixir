defmodule RomanNumerals do

  # List of tuples with all possible values from greatest to least
  @numerals [
  {"M",  1000},
  {"CM",  900},
  {"D",   500},
  {"CD",  400},
  {"C",   100},
  {"XC",   90},
  {"L",    50},
  {"XL",   40},
  {"X",    10},
  {"IX",    9},
  {"V",     5},
  {"IV",    4},
  {"I",     1},
  ]

  # Anchor case
  def numeral(0), do: ""

  @doc """
  Convert the number to a roman number.
  Recursively call this method while subtracting away previous value e.g. numerals(990) => "CM" <> numerals(90) = "CM" <> "XC".
  """

  @spec numeral(pos_integer)  :: String.t()
  def numeral(number) do
    # Find the first decimal value in @numerals which is less than or equal to the given value.
    {roman, int} = Enum.find(@numerals, fn {_roman, int} -> int <= number end)
    roman <> numeral(number - int)
  end
end

