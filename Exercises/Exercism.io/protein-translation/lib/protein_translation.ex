defmodule ProteinTranslation do
  @mapping %{
    "UGU" => "Cysteine",
    "UGC" => "Cysteine",
    "UUA" => "Leucine",
    "UUG" => "Leucine",
    "AUG" => "Methionine",
    "UUU" => "Phenylalanine",
    "UUC" => "Phenylalanine",
    "UCU" => "Serine",
    "UCC" => "Serine",
    "UCA" => "Serine",
    "UCG" => "Serine",
    "UGG" => "Tryptophan",
    "UAU" => "Tyrosine",
    "UAC" => "Tyrosine",
    "UAA" => "STOP",
    "UAG" => "STOP",
    "UGA" => "STOP",
  }

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    case transcribe(rna) do
      :invalid -> {:error, "invalid RNA"}
      proteins -> {:ok, proteins |> Enum.reverse}
    # Parses RNA string into array of 3-bytechar substrings
    end
  end

  defp transcribe(rna) do
    Regex.scan(~r/.{3}/, rna) |> Enum.reduce_while([], fn [codon], proteins ->
      case of_codon(codon) do
        { :ok, "STOP" }  -> { :halt, proteins }
        { :ok, protein } -> { :cont, [ protein | proteins ] }
        { :error, _ }    -> { :halt, :invalid }
      end
    end)
  end

  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon(codon) do
    try do
      {:ok, Map.fetch!(@mapping, codon)}
    rescue
      KeyError -> {:error, "invalid codon"}
    end
  end
end
