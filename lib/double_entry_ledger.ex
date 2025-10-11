defmodule DoubleEntryLedger do
  alias DoubleEntryLedger.AccountType
  alias DoubleEntryLedger.Tigerbeetle

  # id -> use to identify account
  # ledger -> use to identify ledger, each currecy different ledger
  # code -> use to idetify account type
  # flags -> use to store additional information
  # external_id -> use to store additional information
  def create_account(id, ledger, code, external_id \\ 0) do
    flags =
      if code == AccountType.user_balance_liability() do
        %{
          debits_must_not_exceed_credits: true
        }
      else
        %{}
      end

    Tigerbeetle.create_account(id, ledger, code, flags, external_id)
  end

  def lookup_account(id), do: Tigerbeetle.lookup_account(id)
end
