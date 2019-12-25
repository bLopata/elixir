defmodule DndCharacter do
  @type t :: %__MODULE__{
          strength: pos_integer(),
          dexterity: pos_integer(),
          constitution: pos_integer(),
          intelligence: pos_integer(),
          wisdom: pos_integer(),
          charisma: pos_integer(),
          hitpoints: pos_integer()
        }

  defstruct ~w[strength dexterity constitution intelligence wisdom charisma hitpoints]a

  @spec modifier(pos_integer()) :: integer()
  def modifier(score) do
    Integer.floor_div(score - 10, 2)
  end

  @spec ability :: pos_integer()
  def rng do
    for(_ <- 1..4, do: Enum.random(1..6))
    |> Enum.sort()
    |> Enum.drop(1)
    |> Enum.sum()
  end

  @spec character :: t()
  def character do
    constitution = ability()

    %{
      strength: rng(),
      dexterity: rng(),
      constitution: constitution,
      intelligence: rng(),
      wisdom: rng(),
      charisma: rng(),
      hitpoints: 10 + modifier(constitution)
    }
  end
end
