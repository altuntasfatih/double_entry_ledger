defmodule DoubleEntryLedger.Factory do
  use ExMachina

  @spec account_id_sequence() :: any()
  def account_id_sequence, do: sequence(:account_id, &(&1 + 100))
  # 0-100 accounts are reserved

  def user_id_sequence, do: sequence(:user_id, &(&1 + 1))
  def deposit_id_sequence, do: sequence(:deposit_id, &(&1 + 1))
end
