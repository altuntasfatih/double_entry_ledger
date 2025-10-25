defmodule LedgerTest.Factory do
  use ExMachina

  def transaction_id_sequence, do: sequence(:transaction_id, &(&1 + 100))
  def account_id_sequence, do: sequence(:account_id, &(&1 + 10_000))

  def system_account_id_sequence, do: sequence(:system_account_id, &(&1 + 1))
  # 0-100 accounts are reserved for system accounts
end
