[_metadata_:author]: - "benlopata"
[_metadata_:style]: - "blopata.github.io/assets/css/darkdownstyle.css"
[_metadata_:tags]: - "elixir fp"

# Background on Erlang, Elixir, and OTP

[Elixir](https://elixir-lang.org/) is a dynamic, functional programming language designed for building scalable and highly available applications. Elixir leverages the Erlang VM the lastest version of which uses [BEAM](https://en.wikipedia.org/wiki/BEAM_ "Erlang virtual machine") (aka the new BEAM)- Bogdan/Björn's Erlang Abstract Machine - which was developed by two engineers who worked at Ericcson. BEAM is the virtual machine at the core of the Open Telecom Protocol (OTP) which is in turn part of the Erlang Run-Time System (ERTS) which compiles Erlang/Elixir to bytecode to be executed on the BEAM.

## [Basic types in Elixir](https://elixir-lang.org/getting-started/basic-types.html "Elixir Lang - Basic Types")

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
3=> [1, 2, 3]},
a: ":atom keys use key: value",
b: "but they must be listed last"
```

The heirarchy of types in elixir is as follows:

```elixir
number < atom < reference < function < port < pid < tuple < map < list < bitstring
```

```elixir
iex> 1 < :an_atom
true
```

Following the paradigm of functional languages, data types in Elixir are immutable. Any operation performed on a list, for example, create another list rather than modifying the existing list.

## [Operators](https://hexdocs.pm/elixir/1.6.4/operators.html#content "Hex Docs - Operators")

### Comparison operators

```elixir
| Operator | Description           |
| -------- | --------------------- |
| ==       | equality              |
| !=       | inequality            |
| ===      | strict equality       |
| !==      | strict inequality     |
| >        | greater than          |
| <        | less than             |
| <=       | less than equal to    |
| >=       | greater than equal to |
```

### Boolean and negation operators

```elixir
or
and
not
!
```

### Arithmetic operators

```ex
+
-
*
/
```

Join operators `<>` and `++`, as long as the left side is a literal.

The `in` operator is used for membership in a collection or range.

### Unused operators

The following are unused operators which are valid in Elixir

```elixir
|
|||
&&&
<<<
>>>
~>>
<<~
~>
<~
<~>
<|>
^^^
~~~
```

It is possible to bind these operators as well as rebind used operators in Elixir to a custom definition.

```elixir
defmodule WrongMath do
  # Let's make math wrong by changing the meaning of +:
  def a + b, do: a - b
end
```

(_Note: to avoid ambiguity and an error, if rebinding a defined operator, you **must** exclude the associated `[fun: arity]` from the module import._)

```elixir
iex> import WrongMath
iex> import Kernel, except: [+: 2]
```

---

## [Modules](https://elixir-lang.org/getting-started/modules-and-functions.html "Elixir Modules")

Modules provide a namespace for defined functions, macros, structs, protocols, and other modules. Modules are wrapped with

```elixir
defmodule ModuleName do
  # Stuff goes here
end
```

Referencing a function defined inside a module from outside the module requires passing the module name, e.g.

```elixir
ModuleName.some_function()
```

However it can be accessed within the module simply by the function name.

To access a function in a nested module, prefix the function name with all encompassing module names, e.g.

```elixir
ModuleName.OuterModule.InnerModule.my_function()
```

Note that all modules are defined at the top level, Elixir simply prepends the outer module name to the inner module name, placing a dot between the two module names to distinguish.

### Directives in Modules

Elixir has three directives for working with modules. These directives are executed at compile-time and are lexically scoped; that is they are only defined within the scope in which they are declared.

#### _The `import` Directive_

The `import` directive brings another module's functions and or macros into the current scope. This can serve to cut down repeated `ModuleName` prefixes to a function.

```elixir
defmodule Example do
  # so this call to 'List.flatten/1'
  def func1 do
    List.flatten[1,[2,3],4]
  end
  def func 2 do
    # becomes simply 'flatten/1'
    import list, only: [flatten: 1]
    flatten [5,[6,7],8]
  end
```

#### _The `alias` Directive_

The `alias` directive allows for renaming a module for conciseness.

```elixir
defmodule Example do
  def compile_and_go(source) do
    alias My.Other.Module.Parser, as: Parser
    alias My.Other.Module.Runner
    source
    |> Parser.parse()
    |> Runner.execute()
  end
end
```

Note the second `alias` directive leaves off `, as: Parser` because the alias defaults to the last part of the module name. An even more concise method would be

```elixir
alias My.Other.Module.{Parser, Runner}
```

#### _The`require` Directive_

The `require` directive is used when you want to access macros defined within another module. Macros allow for specific definitions of Elixir syntax to inject code. Macros will be discussed further in Chapter 22.

### Module Attributes

Module attributes are associated metadata defined at the top level of a module with

```elixir
@name value
```

Module attributes may be accessed by functions inside the same module and the value is whatever value that attribute had when the function was defined.

```elixir
defmodule ModuleAttribute do
  @coder "Ben Lopata"
  def print_name, do @coder
end
IO.puts "This is code written by #{ModuleAttribute.print_name}"
```

### Module Names in Elixir

Module names in Elixir are atoms. When a variable name has an uppercase first letter, Elixir converts it to an atom and prepends it with `Elixir`. So the `String` or `IO` modules, for example, are in fact `Elixir.String` and `Elixir.IO`

## [Functions](https://elixir-lang.org/getting-started/modules-and-functions.html#named-functions)

Functions in Elixir are defined by their name and their arity (number of input arguments).

The shorthand for a function representation is the function named, followed by a slash and the arity of the function

```elixir
IO.puts/1
```

### Pattern Matching in Function Calls

Pattern matching in function calls is performed by writing what is essentially a `case` or `switch` statement, with multiple function definitions (or multiple clauses) which have different parameter lists and bodies.

Take the following

```elixir
defmodule Factorial do
  def of(0), do: 1
  def of(n), do: n * of(n-1)
end
```

When you called the named function `Factorial.of(n)`, Elixir pattern matches the given parameter with the parameter list of the first function. If that pattern match fails, it proceeds to the next clause with the same arity, and so on.

The known clause (0! = 1) is referred to as the **anchor**. Calling `Factorial.of(2)` tries to match the first clause (n = 2 != 0). Then it binds 2 to n, and evaluates the body of the function, which calls `Factorial.of(1)`, which in turn calls the body of the function with n = 1, which finally calls the anchor clause. Elixir then unwinds the stack, and performs all the multiplication and returns the result.

(_Note: since the functions are called top-down, the anchor clause must be first. Reversing the function calls in the above example will result in a compile error._)

### Private Functions

Private functions can also be used to scope functions only within the current module. A private function is defined using the `defp` macro. It is not possible to scope one 'head' (instantiation of a function) as private and another as public, e.g.

```elixir
def fun(a) when is_list(a), do: true
defp fun(a), do: false
```

### Default Parameters

When defining a function, you can specify a default value to any of the parameters by using

```elixir
param \\ value
```

Elixir compares the number of given parameters in a function call to the number of required parameters (from left to right) and will override default value if the number of parameters in a function call is greater than the number of required parameters.

```elixir

defmodule Params do
  @moduledoc """
  Erroneous functions with multiple heads having default parameters.
  """
  def func(p1, p2 \\ 123), do:   IO.inspect [p1, p2]

  def func(p1, 99), do: IO.puts "you said 99"
end
```

Results in the following error:

```elixir
warning: definitions with multiple clauses and default values require a header. Instead of:

    def foo(:first_clause, b \\ :default) do ... end
    def foo(:second_clause, b) do ... end

one should write:

    def foo(a, b \\ :default)
    def foo(:first_clause, b) do ... end
    def foo(:second_clause, b) do ... end

def func/2 has multiple clauses and defines defaults in one or more clauses
  func_module.exs:4

warning: variable "p1" is unused
  func_module.exs:4

warning: this clause cannot match because a previous clause at line 2 always matches
```

Instead, you should add a function head with no body which contains the default paramters, followed by function(s) using regular parameters.

```elixir
defmodule Params do

  def func(p1, p2 \\ 123)

  def func(p1, p2) when is_list(p1) do
      "You said #{p2} with a list"
  end

  def func(p1, p2), do: "You passed #{p1} and #{p2}"

end
```

### Guard Clauses

Expanding on the concept of pattern matching in functions, Guard Clauses allow for type or value checking for function calls.

```elixir
defmodule Guard do
  def what_is(x) when is_number(x), do: IO.puts "#{x} is a number"
  def what_is(x) when is_atom(x), do: IO.puts "#{x} is a atom"
  def what_is(x) when is_list(x), do: IO.puts "#{x} is a list"
end
```

In our Factorial example above, we can add a Guard clause to protect against a negative integer, i.e.

```elixir
defmodule Factorial do
  def of(0), do: 1
  def of(n) when is_integer(n) and n > 0 do
    n * of(n-1)
  end
end
```

Writing the guard clause differently, i.e.

```elixir
def of(n) do
  if n < 0 do
    raise "factorial called on negative number"
  else
  n * of(n-1)
  end
end
```

defines the `Factorial.of()` method for all values of n, however the first implementation explicitly defines the domain of our function as non-negative integers.

### Anonymous Functions

Anonymous functions are also permitted in Elixir. Anonymous functions are delimeted by the keywords `fn` and `end`, e.g.

```elixir
iex> add = fn a, b -> a + b end
#Function<12.71889879/2 in :erl_eval.expr/5>
iex> add.(1, 2)
3
```

The arguments are listed to the left of the arrow operator and the code to be executed to the right. The anonymous function is stored in the variable `add`. Note the dot (`.`) is required to call an anonymous function. The dot defines the difference between an anonymous function matched to a variable `add` and a named function `add/2`.

Anonymous functions can use pattern matching to define a result for multiple bodies, depending on the type and value of the arguments passed. For instance, error checking in Elixir may be implemented as:

```elixir
anonymous_function = fn
  {:ok, x} -> "First line: #{IO.read(x, :line)}"
  {_, error} -> "Error: #{:file.format_error(error)}"
end
```

Elixir checks for a match against the clauses from top to bottom. If the result of calling `anonymous_function.()` is a tuple `{:ok, x}` the file is opened and the first line is outputted in the terminal. The second clause introduces the wildcard `_` to bind any value in first term of the tuple, provided the second term is `:error`.

For more detail on pattern matching in anonymous functions, see the [fizz_buzz.ex](./Exercises/Programming_Elixir_1.6/5_Anonymous_Functions/fizz_buzz.ex) example from the chapter.

Calling `is_function/2` with the name and arity of the function will return a boolean for the existence of the named function.

### [Capture function (&)](https://elixir-lang.org/getting-started/modules-and-functions.html#function-capturing "Function Capturing")

The capture function in Elixir is a shortcut which can accomplish one of two things:

1. capture a function with a given name and arity from a module which is a handy shorthand to bind a function from a built in module to a local name.
2. to concisely create anonymous functions.

#### _Binding a named function_

```elixir
sayHello = &(IO.puts/1)
sayHello.("hi there") # binds the IO.puts() method to a local name
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

#### _Declaring an anonymous function_

```elixir
add_one = &(1 + 1)
add_one.(1) # 2
```

This is an example of using capture to create an anonymous function. The above can be written out more formally as:

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

![Capture operator in action](/docs/images/capture+operator.jpg)

## [Pipe Operator (|>)](https://elixir-lang.org/getting-started/enumerables-and-streams.html#the-pipe-operator "Pipe Operator")

The |> operator takes the result of the expression to the left of the operator and passes it as the first parameter into the function to the right of the operator, e.g.

```elixir
people = DB.find_customers
orders = Orders.for_customers(people)
tax = sales_tax(orders, 2018)
filing = prepare_filing(tax)
```

Which is a more legible version of

```elixir
prepare_filing(sales_tax(Orders.for_customers(DB.find_customers), 2018))
```

Can be written in Elixir as

```elixir
filing = DB.find_customers
  |> Orders.for_customers
  |> sales_tax(2018)
  |> prepare_filing
```

`val |> f(a,b)` is the same as calling `f(val, a, b)`.

You can also chain pipe operations on a single line

```elixir
iex> (1..10) |> Enum.map(&(&1*&1)) |> Enum.filter(&(&1 < 40))
[1, 4, 9, 16, 25, 36]
```

Note: when using the pipe operator, function parameters need to be wrapped in parentheses.

The pipe operator provides an explicit way to transform data - one of the primary benefits of Elixir and FP in general.

## [Lists And Recursion](https://elixir-lang.org/getting-started/keywords-and-maps.html "Keywords lists and Maps")

Lists in Elixir, for example `[1, 2, 3, 4, 5]` can be represented (and pattern matched or asserted to) `[a, b, c, d, e]` or `[head | tail]`, e.g.

```elixir
iex> [a, b, c] = [1, 2, 3]
[1, 2, 3]
iex> a == 1 and b == 2 and c == 3
true
iex> [head | tail] = [1, 2, 3, 4, 5]
[1, 2, 3, 4, 5]
iex> head
1
iex> tail
[2, 3, 4, 5]
```

This `[head | tail]` syntax can be used to process a list. By definition, the length of an empty list is zero and the length of a non-empty list is 1 + the length of it's tail. Using this definition, we can write a function to return the length of any arbitrary list:

```elixir
defmodule MyList do
  def len([]), do: 0
  def len([head|tail]), do: 1 + len(tail)
end
```

In this example, calling `MyList.len([1, 2, 3, 4, 5])` first matches `head` to the first value in the array, `1` and `tail` is matched to the remaining list elements, `[2, 3, 4, 5]`. This function call is repeated recursively, adding 1 each time, until we reach the **anchor case** of an empty list, `MyList.len([])`.

Elixir also tells us that the value of `head` is not used in the function call, which we can fix by prepending an `_` to the variable name to tell the compiler that that variable will not be used in the function body (`_head`).

We can expand this to return the squares of each element in a list or applying an arbitrary function to a list (creating a map function):

```elixir
def map([], _func), do: []
def map([ head | tail ], func), do: [ func.(head) | map(tail, func) ]
```

Invoking this and passing a list and some function as a second argument evaluates the function provided the first element of the list (`func.(head)`) and then recursively calls the enclosing `map` function on the `tail` of the list. For more information on mapping, see [map.ex](Exercises\Programming_Elixir_1.6\7_Lists_And_Recursion\map.ex).

```elixir
iex> MyList.map [1,2,3,4], fn (n) -> n+1 end
[2, 3, 4, 5]
```

The capture operator can be used in this context to create a shorthand for the anonymous function:

```elixir
iex> MyList.map [1,2,3,4], &(&1+1)
[2, 3, 4, 5]
```

Mapping functions and lists can similarly be applied to return a single value, say the sum of the list:

```elixir
defmodule MyListReduce do
  def reduce([], value, _), do: value
  def reduce([head | tail], value, func) do
    reduce(tail, func.(head, value), func)
  end
end
```

Passing in the list to this function using the capture operator and `+` returns the sum

```elixir
iex> MyListReduce.reduce([1, 2, 3, 4], 0, &(&1+&2))
10
```

We can also pattern match against more complex list patterns, such as this `Swapper` module which recursively rearranges a list:

```elixir
defmodule Swapper do
  def swap([]), do: []
  def swap([a, b | tail]), do: [b, a | swap(tail)]
  def swap([_]), do: raise "You can't swap a list with an odd number of elements."
end

IO.puts Swapper.swap [1, 2, 3, 4, 5, 6] # => [2, 1, 4, 3, 6, 5]
```

Or pattern matching for a specific element in a list of lists:

```elixir
defmodule WeatherHistory do
  def for_location([], _target_loc), do: []
  def for_location([head = [_, target_loc, _, _] | tail], target_loc) do
    [head | for_location(tail, target_loc)]
  end
  def for_location([ _ | tail], target_loc), do: for_location(tail, target_loc)
end
```

## Maps, Keyword Lists, Sets, and Structs

Dictionary data types, those that store key value pairs, are Keyword Lists and Maps.
Dictionary types can be pattern matched against and updated or have functions applied to their values.
Decisions for what data type to use vary based on the application.

Pattern matching? => `%{}`

Multiple entries with the same key? => `Keyword` module.

Order important? => `Keyword` module

Fixed, repeated schema? => `struct`

Else? => `%{}`

### [Keyword Lists](https://hexdocs.pm/elixir/Keyword.html#new/0 "HexDocs - Keyword collection")

Keyword lists are typically used for options passed to functions.

```elixir
defmodule Canvas do
  @defaults [ fg: "black", bg: "white", font: "Merriweather"]

  def draw_test(text, options \\ []) do
    options = Keyword.merge(@defaults, options)
    IO.puts "Drawing text #{inspect(text)}"
    IO.puts "Foreground #{options[:fg]}"
    IO.puts "Background #{Keyword.get(options, :bg)}"
    IO.puts "Font used #{options[:font]}"
  end
end
```

### [Maps](https://hexdocs.pm/elixir/Map.html#content "HexDocs - Map collection")

Maps are the go-to key value store in Elixir. Maps are instantiated with the `%{}` syntax or `Map.new`. Order is not preserved when using a map. Keys can be of any type, but Maps do not allow for duplicate keys (using strict comparison: ===/2). Atom keys allow for `key: value` shorthand rather than using the arrow syntax `key => value`, provided they are at the end. Values can be accessed using `Map.get/3` `Map.fetch/2` or through bracket notation, e.g. `map[]` (as part of the Access module).

Maps can be pattern matched against like other data stores in Elixir.

```elixir
iex> person = %{name: "Ben", height: 1.88}
%{height: 1.88, name: "Ben"}
iex> %{name: a_name} = person
%{height: 1.88, name: "Ben"}
iex>a_name
"Ben"
iex> %{name: _, height: _} = person
%{height: 1.88, name: "Ben"}
iex> %{height: _, weight: _} = person
(MatchError) no match of right hand side value: %{height: 1.88, name: "Ben"}
```

Pattern matching can also be used to update values in maps.

```elixir
iex> n = 1
1
iex>%{n => :one}
%{1 => :one}
iex> %{^n => :one} = %{1 => :one, 2 => :two, 3 => :three}
%{1 => :one, 2 => :two, 3 => :three}
```

You can update _existing_ atom keys by using the update operator `|`

```elixir
iex> map = %{one: 1, two: 2}
iex> %{map | one: "one}
%{one: "one", two: 2}
iex>%{map | three: 3}
** (KeyError) key :three not found
```

### [Structs](https://hexdocs.pm/elixir/Kernel.html#defstruct/1 "HexDocs - Kernel.SpecialForms")

Structs are used when it is necessary to enforce strict typing on a map. Structs are essentially a module that wraps a limited form of a map. Struct keys must be atoms and structs do not support dict capabilities.

```elixir
defmodule Reader do
  defstruct name: "", has_library_card: false, over_18: true
end
```

We then can work with this `Reader` module in iex

```elixir
iex> r1 = %Reader{}
%Reader{name: "", over_18: true, has_library_card: false}
iex> r2 = %Reader{name: "Ben", has_libary_card: true}
%Reader{name: "Ben", over_18: true, has_library_card: true}
```

Fields in a struct can be accessed using dot notation and pattern matching and `|` operator to update function the same as a generic map.

```elixir
iex>r2.has_library_card
true
iex>r3 = %Reader{ r2 | name: "Benjamin" }
%Reader{name: "Benjamin", over_18: true, has_library_card: true}
```

Structs are wrapped in a module to allow for specific logic based on the values

```elixir
defmodule Attendee do
  defstruct name: "", paid: false, over_18: true

  def may_attend_after_party(attendee = %Attendee{}) do
    attendee.paid && attendee.over_18
  end

  def print_vip_badge(%Attendee{name: name}) when name != "" do
    IO.puts "Very cheap badge for #{name}"
  end

  def print_vip_badge(%Attendee{}) do
    raise "missing name for badge"
  end
end
```

### Nested Dictionary Structures

Suppose we have a struct type which is itself a struct, e.g.:

```elixir
defmodule Customer do
  defstruct name: "", company: ""
end

defmodule BugReport do
  defstruct owner: %Customer{}, details: "", severity: 1
end
```

We could then create a report using the above structs:

```elixir
iex> report = %BugReport{owner: %Customer{name: "Ben", company: "Pragmatic"}, details: "its broken"}
%BugReport{details: "broken", owner: %Customer{company: "Pragmatic", name: "Ben"}, severity: 1}
```

We could access properties using dot notation `report.owner.company # => "Pragmatic"` and updated using `|`:

```elixir
report = %BugReport{report | owner: %Customer{ report.owner | company: "PragProg"}}
```

However this is verbose and difficult to comprehend. Enter the `Access` module! Using `put_in/2`, the above can be written simply as:

```elixir
iex> put_in(report.owner.company, "PragProg")
%BugReport{details: "broken", owner: %Customer{company: "PragProg", name: "Ben"}, severity: 1}
```

The `update_in/2` method allows us to apply a function to a struct's field:

```elixir
iex> update_in(report.owner.name, &("Mr. " <> &1))
%BugReport{details: "broken", owner: %Customer{company: "PragProg", name: "Mr. Ben"}, severity: 1}
```

The above methods are actually macros which operate at compile time. As a result, the number of keys you can pass to a particular method is static and the set of keys cannot be passed as parameters between functions.

The methods `get_in` and `get_and_update_in` can optionally take a list of keys as a parameter which changes the implementation from macros (static, processed at compile-time) to functions (dynamic, processed at run-time).

```elixir
| Name              | Macro Parameters | Function Parameters |
| ----------------- | ---------------- | ------------------- |
| get_in            | N/A              | (dict, keys)        |
| put_in            | (path, value)    | (dict, keys, value) |
| update_in         | (path, fn)       | (dict, keys, fn)    |
| get_and_update_in | (path, fn)       | (dict, keys, fn)    |
```

The dynamic versions of `get_in` and `get_and_update_in` can both be passed a function as a key, and will return the values of invoking the function, e.g.:

```elixir
authors = [
  %{name: "José", language: "Elixir"},
  %{name: "Matz", language: "Ruby"},
  %{name: "Larry", language: "Perl"},
]

languages_with_an_r = fn (:get, collection, next_fn) ->
  for row <- collection do
   if String.contains?(row.language, "r"), do: next_fn.(row)
  end
end

IO.inspect get_in(authors, [languages_with_an_r, :name])
#=> ["Jose", nil, "Larry"]
```

This concept of passing a function as a key can be expanded using two methods from the Access module, `all` and `at`:

```elixir
IO.inspect get_in(authors, [Access.all(), :name])
#=> ["José", "Matz", "Larry"]

IO.inspect get_in(authors, [Access.at(1), :language])
#=> "Ruby"

IO.inspect get_and_update_in(authors, [Access.all(), :name], fn (val) -> String.upcase(val) end)
#=> ["JOSE", "MATZ", "LARRY"]
```

And `Access.elem` can access values within a tuple:

```elixir
rappers = [
  %{
    rap_name: {"Slim", "Shady"},
    name: "Marshall Mathers"
  },
  %{
    rap_name: {"Nate", "Dogg"},
    name: "Nathaniel Dwayne Hale"
  }
]


IO.inspect get_and_update_in(rappers, [Access.all(), :rap_name, Access.elem(0)], fn val -> {val, String.reverse(val)} end)

#=>{["Slim", "Nate"],
#  [
#    %{name: "Marshall Mathers", rap_name: # {"milS", "Shady"}},
#    %{name: "Nathaniel Dwayne Hale", # rap_name: {"etaN", "Dogg"}}
#  ]}
```

`Access.key()` lets you specify which element in a dictionary type (maps and structs) to access.

```elixir
cast = %{
  buttercup: %{
    actor: {"Robin", "Wright},
    character: "princess"
  },
  westley: %{
    actor: {"Carey", "Elwes"},
    character: "farm boy"
  }
}

Io.inspect get_and_update_in(cast, [Access.key(:westley), :role], fn val -> {val, "Queen"} end)

#=> {"princess",
#    %{buttercup: %{actor: {"Robin", "Wright"}, role: "Queen"},
#    westley: %{actor: {"Carey", "Elwes"}, role: "farm boy"}}}
```

`Access.pop` allows you to remove an entry with a given key in from a map or keyword list and returns the tuple containing the value associated with the key and the updated container.

### [Sets](https://hexdocs.pm/elixir/MapSet.html#content "HexDocs - MapSet collection")

Sets are implemented using the `Mapsets` module.

```elixir
iex> set1 = 1..5 |> Enum.into(MapSet.new)
#MapSet<[1, 2, 3, 4, 5]>
iex> set2 = 3..8 |> Enum.into(MapSet.new)
#MapSet<[3, 4, 5, 6, 7, 8]>
iex> MapSet.member? set1, 3
true
iex> MapSet.union set1, set2
#MapSet<[1, 2, 3, 4, 5, 6, 7, 8]>
iex> MapSet.difference set1, set2
#MapSet<[1, 2]>
iex> MapSet.difference set2, set1
#MapSet<[6, 7, 8]>
iex> MapSet.intersection set2, set1
#MapSet<[3, 4, 5]>
```

## Using The [Enum](https://hexdocs.pm/elixir/Enum.html "HexDocs - Enum module") and [Stream](https://hexdocs.pm/elixir/Stream.html "HexDocs - Stream module") Modules to Process Collections

Elixir has a number of types that act as collections: lists, maps, ranges, files, and even functions are all examples of collections. All collections can be iterated through, and some can be added to. Things that can be iterated are said to belong to the `Enumerable` protocol. The two primary modules for dealing with collections are `Enum` and `Stream`. The `Enum` module contains a vast array of methods for dealing with collections, parsing and filtering inputs, splitting and joining, indexing, mapping, etc. `Enum` methods can be performed in linear time, and are eager (they traverse the enumerable as soon as they are invoked) - thus it is sometimes useful to use the `Stream` module. `Stream` offers the ability to perform lazy composition and computation - while iterating, the subsequent value is only calculated when it is needed.

To show the benefits of the `Stream` module, take this pipeline which parses a file and returns the longest word contained in a dictionary:

```elixir
IO.puts File.read!("/usr/share/dict/words")
  |> String.split
  |> Enum.max_by(&String.length/1)
```

This code reads the entire file into memory, splits the file into a list of words, and processes that list in memory to find the longest word. These calls to `Enum` methods are self-contained: they consume and return a collection. Enter `Stream` to process the elements as we need them, and not make costly duplications in memory.

```elixir
IO.inspect 1..4
  |> Stream.map(&(&1*&1))
  |> Stream.map(&(&1+1))
  |> Stream.filter(&rem(&1, 2) == 1)
  |> Enum.to_list

# => [5, 17]
```

The `Stream` module passes successive elements of each collection into the next in the pipeline. Now our code for the longest-word can be optimized to:

```elixir
IO.puts File.open!("usr/share/dict/words")
  |> IO.stream(:line)
  |> Enum.max_by(&String.length/1)
```

`IO.Stream` converts an IO device (the open file) into a stream which processes one line at a time. This can be shortened to `File.stream!("usr/share/dict/words") |> Enum.max_by(&String.length/1)`.

While slower, the `Stream` module's implementation shines in certain use cases, for example reading data from a server. With the `Enum` module, we would need to wait for the entire collection to arrive before any processing can be completed - and the data could be infinite. With streams we can process them as they arrive.

With infinte streams, there are a few methods which are useful `Stream.iterate`, `Stream.repeatedly`, `Stream.cycle`, `Stream.unfold`, and `Stream.resource`.

`Stream.iterate(start_value, next_fun)` generates an infinite stream beginning with `start_value`, and then applying `next_fun` to this value ad infinitum.

`Stream.repeatedly` takes a function and invokes it each time a new value is requested.

`Stream.cycle` takes an enumerable and returns an infinite stream containing that enumerable's elements. If the end of the enumerable is reached, it simply restarts from the beginning.

`Stream.unfold` allows for explicit typing of values output to the stream as well as values passed to the next iteration. You supply an initial value and a function, like with `Stream.iterate`, the function uses the argument to create a two-value tuple. The first element of the return is the value returned by this iteration, and the next element is the value to be passed to the next iteration of the stream, terminating upon reaching a `nil` value. The general form of the function is

```elixir
fn state -> {stream_value, new_state} end
```

```elixir
IO.inspect Stream.unfold({0,1}, fn {f1, f2} -> {f1, {f2, f1+f2}} end) |> Enum.take(15)
# => [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377]
```

`Stream.resorce` builds upon `Stream.unfold` as a means to interact with an external resource, such as reading a file's contents. The first parameter is not a value, but rather a function that returns a value. The third parameter is what the stream should do when it is done with the resource such as closing a file and deallocating any resources.

```elixir
Stream.resource(fn -> File.open!("sample") end,
  fn file ->
    case IO.read(file, :line) do
      data when is_binary(data) -> {[data], file}
      _ -> {:halt, file}
    end
  end
  fn file -> File.close(file) end)
```

This example first opens the file when the stream becomes active, reads each line from the input file, returning either the line's contents and the file as a tuple or a `:halt` tuple at the end of the file, and finally closing the file.

### Comprehensions

Comprehensions provide a shortcut for mapping and filters collections which are concise and idiomatic. Comprehensions take one or more collections as inputs, extracting all combinations of values for each, optionally filtering the resultant values, and generates a new collection using the remaining values.

```elixir
iex> for x <- Enum.into(1..5, []), do: x * x
[1, 4, 9, 16, 25]
iex> for x <- [1, 2, 3, 4, 5], x < 4, do: x * x
[1, 4, 9]
```

`x <- [1, 2, 3]` says that we want to first run the `do` block of the comprehension with `x = 1`, then 2 then 3. For multiple generators, the operations are nested, so the comprehension:

```elixir
for x <- [1, 2], y <- [5, 6], do: x * y
[5, 6, 10, 12]
```

evaluates as `x=1`, `y=5`, `x=1`, `y=6`, `x=2`, `y=5`, `x=2`, `y=6`.

A filter in a comprehension acts as a predicate. If the condition evaluates to false, the comprehension moves to the next iteration without evaluating the `do` block.

Bitstrings, including binaries and strings, also work using comprehensions.

```elixir
iex> for <<ch <- "hello">>>, do: ch
'hello'
iex> for <<ch <- "hello">>, do: <<ch>>
["h", "e", "l", "l", "o"]
```

The first comprehension evaluates to a charcode list [104, 101, 108, 108, 111] which elixir evaluates to `hello`. In the next case, the `do` block converts the result back into a string, which is evaluated to be a list of one-character strings.

All variable assignments inside a comprehension are scoped locally to that comprehension and will not affect variables in the outer scope:

```elixir
iex> name = "Ben"
Ben
iex> for name <- ['Neptune', 'Jupiter'], do: String.upcase(name)
["NEPTUNE", "JUPITER"]
iex> name
Ben
```

The `into:` option allows for returning collections other than the default list. The collection does not need to be empty, so you can append values to a map using a comprehension.

## [Strings and Binaries](https://hexdocs.pm/elixir/String.html#content "HexDocs - Strings")
