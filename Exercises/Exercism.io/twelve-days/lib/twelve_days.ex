defmodule TwelveDays do
  @gifts [
    {1, "first", "a partridge in a pear tree"},
    {2, "second", "two Turtle Doves"},
    {3, "third", "three French Hens"},
    {4, "fourth", " four Calling Birds"},
    {5, "fifth", "five Gold rings"},
    {6, "sixth", "six Geese-a-Laying"},
    {7, "seventh", "seven Swans-a-Swimming"},
    {8, "eighth", "eight Maids-a-Milking"},
    {9, "ninth", "nine Ladies Dancing"},
    {10, "tenth", "ten Lords-a-Leaping, "},
    {11, "eleventh", "eleven Pipers Piping"},
    {12, "twelfth", "twelve Drummers Drumming"}
  ]

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number) do
    for {num, day, presents} when num < number <- @gifts do
      for present <- presents, do: Enum.intersperse(present, ", ")
    end
  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing do
  end
end
