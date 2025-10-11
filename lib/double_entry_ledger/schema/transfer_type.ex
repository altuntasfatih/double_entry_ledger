defmodule DoubleEntryLedger.Schema.TransferType do
  @type transfer_type ::
          :deposit
          | :withdrawal

  @code %{
    :deposit => 1,
    :withdrawal => 2
  }

  def deposit, do: @code[:deposit]
  def withdrawal, do: @code[:withdrawal]
end
