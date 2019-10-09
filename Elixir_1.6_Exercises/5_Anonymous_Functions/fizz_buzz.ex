fizz_buzz = fn
  0, 0, _ -> IO.puts "Fizz Buzz"
  0, _, _ -> IO.puts "Fizz "
  _, 0, _ -> IO.puts "Buzz"
  _, _, n -> IO.puts n
end
