defmodule DoubleEntryLedger.Schema.Ledger do
  @type ledger_ ::
          :royal_casino_usd

  @code %{
    :royal_casino_usd => 1000
  }

  @spec default_casino_ledger() :: any()
  def default_casino_ledger, do: @code[:royal_casino_usd]
end
