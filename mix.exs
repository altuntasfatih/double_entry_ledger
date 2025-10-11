defmodule DoubleEntryLedger.MixProject do
  use Mix.Project

  def project do
    [
      app: :double_entry_ledger,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {DoubleEntryLedger.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  def deps do
    [
      {:tigerbeetlex, "~> 0.16.60"}
    ]
  end
end
