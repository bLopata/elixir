defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
<<<<<<< Updated upstream
  def nth(count) when count < 1, do: raise "error"
  def nth(count) when count == 1, do: 2
  def nth(count) do
    :idktbh
  end
=======
  def nth(count) when count < 1, do: raise("error")

  def nth(count) do
    Stream.iterate(2, &(&1 + 1))
    |> Stream.filter(&is_prime?/1)
    |> Enum.take(count)
    |> List.last()
  end

  # Initial case (n=2)
  defp is_prime?(2), do: true
  # Even numbers larger than 2 aren't prime.
  defp is_prime?(n) when n < 2 or rem(n, 2) == 0, do: false
  # Checks for odd numbers that are multiples of 3 initially.
  defp is_prime?(n), do: handle_odd(n, 3)

  # Parses smaller odd numbers (3, 5, 7)
  defp handle_odd(n, k) when n < k * k, do: true
  # Checks for multiples of odd primes.
  defp handle_odd(n, k) when rem(n, k) == 0, do: false
  # Parses larger numbers, incrementing by 2 to remain odd.
  defp handle_odd(n, k), do: handle_odd(n, k + 2)
>>>>>>> Stashed changes
end
