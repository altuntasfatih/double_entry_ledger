defmodule LedgerTest.Factory do
  use ExMachina

  @spec account_id_sequence() :: any()
  def account_id_sequence, do: sequence(:account_id, &(&1 + 100))

  def cash_asset_account_id_sequence, do: sequence(:cash_asset_account_id, &(&1 + 1))
  # 0-100 accounts are reserved for system accounts

  def deposit_id_sequence, do: sequence(:deposit_id, &(&1 + 10_000))
  def withdrawal_id_sequence, do: sequence(:withdrawal_id, &(&1 + 20_000))
end
