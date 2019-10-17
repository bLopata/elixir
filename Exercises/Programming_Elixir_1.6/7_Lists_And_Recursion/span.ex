defmodule MyList do
  def span(from, to), do: [from | span(to)]
end

IO.inspect MyList.span(3, 12)
