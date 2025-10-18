defmodule Ledger.Schema.CasinoLedger do
  @type casino_name() ::
          :royal_casino_usd

  @code %{
    :royal_casino_usd => 1000
  }

  @spec default_casino() :: integer() | nil
  def default_casino, do: Map.get(@code, :royal_casino_usd)
end
