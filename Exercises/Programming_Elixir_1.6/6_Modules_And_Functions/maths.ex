defmodule MathStuff do
  def sum(0), do: 0
  def sum(n), do: n + sum(n-1)

  def gcd(x, 0), do: x
  def gcd(x,y), do: gcd(y, rem(x,y))

  def right_point([head | tail]), do: when rem(head, 3) + rem(head, 5) == 0, do: IO.puts "rightpoint"
  def right_point([head | tail]), do: when rem(head, 3) == 0, do: IO.puts "right"
  def right_point([head | tail]), do: when rem(head, 5) == 0, do: IO.puts "point"
  end
end
