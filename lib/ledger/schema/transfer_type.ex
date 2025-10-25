defmodule Ledger.Schema.TransferType do
  @type transfer_type ::
          :deposit
          | :withdrawal

  @code %{
    :deposit => 1,
    :withdrawal => 2,
    :bet => 3
  }

  def deposit, do: @code[:deposit]
  def withdrawal, do: @code[:withdrawal]
  def bet, do: @code[:bet]
end
