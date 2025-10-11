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
  def create_account(id, code, external_id \\ 0) do
    flags =
      if code == Account.user_balance_liability_code() do
        %{
          debits_must_not_exceed_credits: true
        }
      else
        %{}
      end

    Tigerbeetle.create_account(id, Ledger.default_casino_ledger(), code, flags, external_id)
  end

  def lookup_account(id), do: Tigerbeetle.lookup_account(id)

  def fetch_account(account_id, code) do
    case lookup_account(account_id) do
      {:ok, %{id: account_id, code: ^code}} -> {:ok, account_id}
      _ -> {:error, :account_not_found}
    end
  end

  def query_account(code, ledger) do
    Tigerbeetle.query_accounts(ledger, code, 0)
  end

  def ensure_cash_external_asset_account do
    case query_account(Account.cash_external_asset_code(), Ledger.default_casino_ledger()) do
      {:ok, [%{id: cash_external_asset_id}]} ->
        {:ok, cash_external_asset_id}

      _ ->
        create_account(
          Account.static_account_ids(:cash_external_asset),
          Account.cash_external_asset_code()
        )
    end
  end

  def top_up_user_account(id, account_id, amount) when amount > 0 do
    with {:ok, %{id: user_balance_liability_id}} <-
           fetch_account(account_id, Account.user_balance_liability_code()),
         {:ok, %{id: cash_external_asset_id}} <- ensure_cash_external_asset_account() do
      top_up(
        id,
        user_balance_liability_id,
        cash_external_asset_id,
        Ledger.default_casino_ledger(),
        amount
      )
    end
  end

  def top_up(top_up_id, user_balance_liability_id, cash_external_asset_id, ledger, amount)
      when amount > 0 do
    _transfer = %TigerBeetlex.Transfer{
      id: <<top_up_id::128>>,
      debit_account_id: ID.from_int(cash_external_asset_id),
      credit_account_id: ID.from_int(user_balance_liability_id),
      ledger: ledger,
      code: TransferType.deposit(),
      amount: amount,
      flags: struct(TigerBeetlex.TransferFlags, %{})
    }
  end
end
