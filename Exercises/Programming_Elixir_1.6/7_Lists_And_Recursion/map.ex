defmodule MapSum do
  def map_sum([], _func), do: 0
  def map_sum([head | tail], func), do: func.(head) + map_sum(tail, func)
end

defmodule ArrMax do
  def max([]), do: []
  def max([head | tail]), do: max(head, max(tail))
end

defmodule AddN do
  def caesar([], _n), do: []
  def caesar([head | tail], n) when head + n <= ?z, do: [head + n | caesar(tail, n)]
  def caesar([head | tail], n ), do: [head + n - 26 | caesar(tail, n)]
end
