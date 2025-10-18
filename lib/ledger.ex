defmodule Ledger do
  alias Ledger.Schema.Account
  alias Ledger.Schema.TransferType
  alias TigerBeetlex.ID

  alias Ledger.Tigerbeetle

  # id -> use to identify account
  # code -> use to idetify account type
  # flags -> use to store additional information
  # external_id -> use to store additional information, could be user id, game id, etc.
  def create_user_account(account_id, external_id \\ 0) do
    flags =
      %{
        debits_must_not_exceed_credits: true
      }

    Tigerbeetle.create_account(
      account_id,
      default_casino_ledger_id(),
      user_liability_code(),
      flags,
      external_id
    )
  end

  def deposit_to_user_account(deposit_id, user_account_id, amount) when amount > 0 do
    with {:ok, %{id: user_liability_id, ledger: ledger}} <-
           fetch_account(user_account_id, user_liability_code()),
         {:ok, %{id: cash_asset_id, ledger: ^ledger}} <-
           ensure_cash_asset_account(),
         {:ok, []} <-
           deposit(
             deposit_id,
             user_liability_id,
             cash_asset_id,
             ledger,
             amount
           ) do
      :ok
    end
  end

  def withdraw_from_user_account(withdrawal_id, user_account_id, amount) when amount > 0 do
    with {:ok, %{id: user_liability_id, ledger: ledger}} <-
           fetch_account(user_account_id, user_liability_code()),
         {:ok, %{id: cash_asset_id, ledger: ^ledger}} <-
           ensure_cash_asset_account(),
         {:ok, []} <-
           withdraw(
             withdrawal_id,
             user_liability_id,
             cash_asset_id,
             ledger,
             amount
           ) do
      :ok
    end
  end

  defp deposit(deposit_id, user_liability_id, cash_asset_id, ledger, amount)
       when amount > 0 and is_binary(user_liability_id) and
              is_binary(cash_asset_id) do
    %TigerBeetlex.Transfer{
      id: <<deposit_id::128>>,
      debit_account_id: cash_asset_id,
      credit_account_id: user_liability_id,
      ledger: ledger,
      code: TransferType.deposit(),
      amount: amount,
      flags: struct(TigerBeetlex.TransferFlags, %{})
    }
    |> Tigerbeetle.create_transfer()
  end

  defp withdraw(withdrawal_id, user_liability_id, cash_asset_id, ledger, amount)
       when amount > 0 and is_binary(user_liability_id) and
              is_binary(cash_asset_id) do
    %TigerBeetlex.Transfer{
      id: <<withdrawal_id::128>>,
      debit_account_id: user_liability_id,
      credit_account_id: cash_asset_id,
      ledger: ledger,
      code: TransferType.withdrawal(),
      amount: amount,
      flags: struct(TigerBeetlex.TransferFlags, %{})
    }
    |> Tigerbeetle.create_transfer()
  end

  defp fetch_account(account_id, code) do
    case Tigerbeetle.lookup_account(account_id) do
      {:ok, %{code: ^code} = acc} -> {:ok, acc}
      _ -> {:error, :account_not_found}
    end
  end

  defp ensure_cash_asset_account do
    cash_account_id = cash_asset_account_id()
    code = cash_asset_account_code()
    ledger = default_casino_ledger_id()

    with {:error, :not_found} <- Tigerbeetle.query_accounts(ledger, code, cash_account_id, 1),
         {:ok, _} <-
           Tigerbeetle.create_account(cash_account_id, ledger, code, %{}, cash_account_id) do
      {:ok,
       %{
         id: ID.from_int(cash_account_id),
         ledger: ledger
       }}
    else
      {:ok, [acc]} -> {:ok, acc}
    end
  end

  defp user_liability_code, do: Account.user_liability_code()

  defp cash_asset_account_code, do: Account.cash_asset_code()

  defp cash_asset_account_id do
    Application.get_env(:ledger, :ledger_details)[:cash_asset_account_id]
  end

  defp default_casino_ledger_id do
    Application.get_env(:ledger, :ledger_details)[:default_casino_ledger_id]
  end
end
