defmodule DoubleEntryLedger.Ledger do
  @type ledger_ ::
          :royal_casino_usd

  @code %{
    :royal_casino_usd => 1000
  }

  @spec royal_casino_usd() :: any()
  def royal_casino_usd, do: @code[:royal_casino_usd]
end
