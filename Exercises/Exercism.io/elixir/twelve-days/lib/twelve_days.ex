defmodule TwelveDays do
  @gifts [
    {1, "first", "a Partridge in a Pear Tree"},
    {2, "second", "two Turtle Doves"},
    {3, "third", "three French Hens"},
    {4, "fourth", "four Calling Birds"},
    {5, "fifth", "five Gold Rings"},
    {6, "sixth", "six Geese-a-Laying"},
    {7, "seventh", "seven Swans-a-Swimming"},
    {8, "eighth", "eight Maids-a-Milking"},
    {9, "ninth", "nine Ladies Dancing"},
    {10, "tenth", "ten Lords-a-Leaping"},
    {11, "eleventh", "eleven Pipers Piping"},
    {12, "twelfth", "twelve Drummers Drumming"}
  ]

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(start_num \\ 1, number) do
    list = for {num, _day, presents} when start_num <= num and num <= number <- @gifts, into: [], do: presents
    {_, day, _} = List.keyfind(@gifts, number, 0)
    cond do
      length(list) > 1 ->
        list = list |> Enum.map_every(number, fn x -> "and " <> x end) |> Enum.reverse() |> Enum.intersperse(", ")
        "On the #{day} day of Christmas my true love gave to me: #{list}."
      length(list) == 1 ->
        "On the #{day} day of Christmas my true love gave to me: #{list}."
    end

  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    # Enum.join((for num <- starting_verse..ending_verse, do: verse(num)), "\n")
    starting_verse..ending_verse |> Enum.map_join("\n", &verse(&1))
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing do
    1..12 |> Enum.map_join("\n", &verse(&1))
  end
end
