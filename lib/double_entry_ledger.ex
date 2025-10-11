defmodule DoubleEntryLedger do
  alias DoubleEntryLedger.Tigerbeetle

  # id -> use to identify account
  # ledger -> use to identify ledger, each currecy different ledger
  # code -> use to idetify account type
  # flags -> use to store additional information
  # user_data_128 -> use to store additional information
  def create_account(id, ledger, code, flags \\ %{}, user_data_128 \\ 0) do
    Tigerbeetle.create_account(id, ledger, code, flags, user_data_128)
  end

  def lookup_account(id), do: Tigerbeetle.lookup_account(id)
end
