defmodule DoubleEntryLedger.Factory do
  use ExMachina

  def account_id_sequence, do: sequence(:account_id, &(&1 + 1))
end
