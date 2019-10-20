defmodule SecretHandshake do
  use Bitwise

  @mapping %{0b1 => "wink", 0b10 => "double blink", 0b100 => "close your eyes", 0b1000 => "jump"}
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) when code < 0b10000 do
    @mapping
    |> Enum.filter(fn {key, _} -> key == (key &&& code) end)
    |> Enum.map(fn {_, val} -> val end)
  end

  def commands(code), do: Enum.reverse(commands(code - 0b10000))
end
