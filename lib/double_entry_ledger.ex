defmodule DoubleEntryLedger do
  alias DoubleEntryLedger.Schema.Account
  alias DoubleEntryLedger.Schema.TransferType
  alias TigerBeetlex.ID

  alias DoubleEntryLedger.Schema.Ledger
  alias DoubleEntryLedger.Tigerbeetle

  # id -> use to identify account
  # code -> use to idetify account type
  # flags -> use to store additional information
  # external_id -> use to store additional information
  def create_user_account(account_id, external_id \\ 0) do
    flags =
      %{
        debits_must_not_exceed_credits: true
      }

    Tigerbeetle.create_account(
      account_id,
      Ledger.default_casino_ledger(),
      Account.user_balance_liability_code(),
      flags,
      external_id
    )
  end

  def deposit(deposit_id, account_id, amount) when amount > 0 do
    with {:ok, %{id: user_liability_id, ledger: ledger}} <-
           fetch_account(account_id, Account.user_balance_liability_code()),
         {:ok, %{id: cash_asset_id, ledger: ^ledger}} <-
           ensure_cash_external_asset_account() do
      IO.inspect(user_liability_id, label: "user_liability_id")
      IO.inspect(cash_asset_id, label: "cash_asset_id")

      deposit(
        deposit_id,
        user_liability_id,
        cash_asset_id,
        ledger,
        amount
      )
    end
  end

  defp deposit(deposit_id, user_balance_liability_id, cash_external_asset_id, ledger, amount)
       when amount > 0 do
    _transfer = %TigerBeetlex.Transfer{
      id: <<deposit_id::128>>,
      debit_account_id: ID.from_int(cash_external_asset_id),
      credit_account_id: ID.from_int(user_balance_liability_id),
      ledger: ledger,
      code: TransferType.deposit(),
      amount: amount,
      flags: struct(TigerBeetlex.TransferFlags, %{})
    }
  end

  defp fetch_account(account_id, code) do
    case Tigerbeetle.lookup_account(account_id) do
      {:ok, %{code: ^code} = acc} -> {:ok, acc}
      _ -> {:error, :account_not_found}
    end
  end

  defp ensure_cash_external_asset_account do
    IO.inspect(
      Tigerbeetle.query_accounts(
        Ledger.default_casino_ledger(),
        Account.cash_external_asset_code(),
        Account.static_account_ids(:cash_external_asset),
        1
      ),
      label: "cash_external_asset_account"
    )

    with {:error, :accounts_not_found} <-
           Tigerbeetle.query_accounts(
             Ledger.default_casino_ledger(),
             Account.cash_external_asset_code(),
             Account.static_account_ids(:cash_external_asset),
             1
           ) do
      Tigerbeetle.create_account(
        Account.static_account_ids(:cash_external_asset),
        Ledger.default_casino_ledger(),
        Account.cash_external_asset_code(),
        %{},
        Account.static_account_ids(:cash_external_asset)
      )
    end
  end
end
