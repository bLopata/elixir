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
3=> [1, 2, 3]}
```

The heirarchy of types in elixir is as follows:

<pre><code>number < atom < reference < function < port < pid < tuple < map < list < bitstring</pre></code>

```elixir
iex> 1 < :an_atom
true
```

Following the paradigm of functional languages, data types in Elixir are immutable. Any operation performed on a list, for example, create another list rather than modifying the existing list.

## [Operators](https://hexdocs.pm/elixir/1.6.4/operators.html#content "Hex Docs - Operators")

### Comparison operators

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

### Boolean and negation operators

<code>
<li>or
<li>and
<li>not
<li>!
</code>

### Arithmetic operators

<code>
<li>+ 
<li>- 
<li>*
<li>/
</code>

Join operators <> and ++, as long as the left side is a literal.

The in operator is used for membership in a collection or range.

### Unused operators

The following are unused operators which are valid in Elixir

<code>
<li>|
<li>|||
<li>&&&
<li><<<
<li>>>>
<li>~>>
<li><<~
<li>~>
<li><~
<li><~>
<li><|>
<li>^^^
<li>~~~
</code>

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

## Directives in Modules

Elixir has three directives for working with modules. These directives are executed at compile-time and are lexically scoped; that is they are only defined within the scope in which they are declared.

### The Import Directive

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

### The alias Directive

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

### The require Directive

The `require` directive is used when you want to access macros defined within another module. Macros allow for specific definitions of Elixir syntax to inject code. Macros will be discussed further in Chapter 22.

## Module Attributes

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

# [Functions](https://elixir-lang.org/getting-started/modules-and-functions.html#named-functions)

Functions in Elixir are defined by their name and their arity (number of input arguments).

The shorthand for a function representation is the function named, followed by a slash and the arity of the function

```elixir
IO.puts/1
```

## Pattern Matching in Function Calls

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

## Private Functions

Private functions can also be used to scope functions only within the current module. A private function is defined using the `defp` macro. It is not possible to scope one 'head' (instantiation of a function) as private and another as public, e.g.

```elixir
def fun(a) when is_list(a), do: true
defp fun(a), do: false
```

## Default Parameters

When defining a function, you can specify a default value to any of the parameters by using

```
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

```
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

## Guard Clauses

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

## Anonymous Functions

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

For more detail on pattern matching in anonymous functions, see the [fizz_buzz.ex](Exercises\Programming_Elixir_1.6\5_Anonymous_Functions\fizz_buzz.ex) example from the chapter.

Calling `is_function/2` with the name and arity of the function will return a boolean for the existence of the named function.

## [Capture function (&)](https://elixir-lang.org/getting-started/modules-and-functions.html#function-capturing "Function Capturing")

The capture function in Elixir is a shortcut which can accomplish one of two things:

1. capture a function with a given name and arity from a module which is a handy shorthand to bind a function from a built in module to a local name.
2. to concisely create anonymous functions.

### Binding a named function

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

### Declaring an anonymous function

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

```
people = DB.find_customers
orders = Orders.for_customers(people)
tax = sales_tax(orders, 2018)
filing = prepare_filing(tax)
```

Which is a more legible version of

```
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

## Lists And Recursion

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

We can expand this to return the squares of each element in a list, summing a list, or applying an arbitrary function to a list (creating a map function)

```elixir
def map([], _func), do: []
def map([ head | tail ], func), do: [ func.(head) | map(tail, func) ]
```

Invoking this and passing a list and some function as a second argument evaluates the function provided the first element of the list (`func.(head)`) and then recursively calls the enclosing `map` function on the `tail` of the list.

```elixir
iex> MyList.map [1,2,3,4], fn (n) -> n+1 end
[2, 3, 4, 5]
```

The capture operator can be used in this context to create a shorthand for the anonymous function

```elixir
iex> MyList.map [1,2,3,4], &(&1+1)
[2, 3, 4, 5]
```
