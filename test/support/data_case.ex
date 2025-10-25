defmodule LedgerTest.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Ledger.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias Ledger.Schema.Account

  using do
    quote do
      alias Ledger.Schema.Account
      alias Ledger.Tigerbeetle
      alias TigerBeetlex.ID

      import LedgerTest.DataCase
      import LedgerTest.Factory
    end
  end

  def create_user_account() do
    user_account_id = LedgerTest.Factory.account_id_sequence()
    assert :ok = Ledger.create_user_account(user_account_id, user_account_id)
    user_account_id
  end

  def deposit_to_user_account(user_account_id, amount) do
    assert :ok =
             Ledger.deposit_to_user_account(
               LedgerTest.Factory.transaction_id_sequence(),
               user_account_id,
               amount
             )
  end

  def set_new_cash_asset_account do
    cash_asset_account_id = LedgerTest.Factory.system_account_id_sequence()

    details =
      Application.get_env(:ledger, :ledger_details)
      |> Keyword.put(:cash_asset_account_id, cash_asset_account_id)

    :ok = Application.put_env(:ledger, :ledger_details, details)
    cash_asset_account_id
  end

  def user_liability_code, do: Account.user_liability_code()
  def cash_asset_code, do: Account.cash_asset_code()

  def default_casino_ledger_id,
    do: Application.get_env(:ledger, :ledger_details)[:default_casino_ledger_id]
end
