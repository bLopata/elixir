defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count < 1, do: raise "error"
  def nth(count) when count == 1, do: 2
  def nth(count) do
    :idktbh
  end
end
