defmodule Wallet do
  alias Ledger.Schema.Account

  def get_wallet(wallet_id) when is_integer(wallet_id) do
    Ledger.fetch_account(wallet_id, Account.user_liability_code())
  end

  def create_wallet(wallet_id, external_id \\ 0) when is_integer(wallet_id) do
    Ledger.create_user_account(wallet_id, external_id)
  end

  def deposit(tx_id, wallet_id, amount) when is_integer(wallet_id) do
    Ledger.deposit_to_user_account(tx_id, wallet_id, amount)
  end

  def withdraw(tx_id, wallet_id, amount)
      when is_integer(wallet_id) do
    Ledger.withdraw_from_user_account(tx_id, wallet_id, amount)
  end
end
