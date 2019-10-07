# Elixir

## Basic types in Elixir
```elixir
1          # integer
0x1F       # integer
1.0        # float
true       # boolean
:atom      # atom / symbol
'hello'    # charlist
"elixir"   # string
[1, 2, 3]  # list
{1, 2, 3}  # tuple
%{1=> :ok, # map
2=> "a", 
3=> [1, 2, 3]}
```

Data types in Elixir are immutable, and any operation performed on a list, for example, create another list rather than modifying the existing list.

## Shell
To invoke the Elixir shell, type `iex` into the console.

## Functions
Functions in Elixir are defined by their name and their arity (number of input arguments).

The shorthand for a function representation is the function named, followed by a slash and the arity of the function
```elixir
IO.puts/1
```

Anonymous functions are also permitted in Elixir. Anonymous functions are delimeted by the keywords `fn` and `end`, e.g.
```elixir
iex> add = fn a, b -> a + b end
#Function<12.71889879/2 in :erl_eval.expr/5>
iex> add.(1, 2)
3
```
The arguments are listed to the left of the arrow operator and the code to be executed to the right. The anonymous function is stored in the variable `add`. Note the dot (`.`) is required to call an anonymous function. The dot defines the difference between an anonymous function matched to a variable `add` and a named function `add/2`.

Calling `is_function/2` with the name and arity of the function will return a boolean for the existence of the named function.

### Capture function (&)
The capture function in Elixir is a shortcut which can accomplish one of two things: 
  * capture a function with a given name and arity from a module which is a handy shorthand to bind a function from a built in module to a local name
  ```elixir
sayHello = &(IO.puts/1)
sayHello.("hi there) # binds the IO.puts() method to a local name
```
This example shows binding a function (`IO.puts()`) to a locally scoped name (`sayHello`)

```elixir
defmodule Issues.TableFormatter do
    def make_columnar_table(data_by_colums, format) do
        Enum.each(data_by_colums, &put_in_one_row/1)
    end

    def put_in_one_row(fields) do
        # do something else
    end
end
```
In this example, both functions are in the same module, so you do not need to specify the module name as with `IO.puts()`.
  * the capture function can also be used to create anonymous functions, i.e.:
```elixir
add_one = &(1 + 1)
add_one.(1) # 2
```
The above can be written out more formally as:
```elixir
add_one = fn x -> x + 1 end
add_one.(1) # 2
```

The `&1` is known as a **value placeholder**, which identifies the *n*th argument of the function.

Additionally, lists ({} and []) are also operators in elixir, so the value placeholder and capture function works within them as well.

```elixir
return_list = &[&1, 2]
return_list.(1, 2) # [1, 2]

return_tuple = &{&1, 2}
return_tuple.(1, 2) # {1, 2}
```

![Capture operator in action](../docs/images/capture+operator.jpg)