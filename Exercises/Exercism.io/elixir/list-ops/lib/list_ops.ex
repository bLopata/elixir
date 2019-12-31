defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l) do
    l |> reduce(0, fn (_, acc) -> acc + 1 end)
  end

  @spec reverse(list) :: list
  def reverse(l) do
    l |> reduce([], &[&1 | &2])
  end

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    l |> reduce([], &[f.(&1) | &2]) |> reverse
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    l |> reduce([], &( if f.(&1), do: [&1 | &2], else: &2 ))
    |> reverse
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _), do: acc
  def reduce([head | tail], acc, f) do
    reduce(tail, f.(head, acc), f)
  end

  @spec append(list, list) :: list
  def append(a, b) do
    a |> reverse
    |> reduce(b, &[&1 | &2])
  end

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    ll |> reverse
    |> reduce([], &append/2)
  end
end
