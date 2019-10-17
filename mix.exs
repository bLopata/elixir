defmodule Readme.MixProject do
  use Mix.Project


  def project do
    [
      app: :readme,
      version: "0.1.0",
      # elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end
  defp deps do
    [{:exjson, "~> 0.6.0"}]
  end
end
