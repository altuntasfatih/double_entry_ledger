defmodule DoubleEntryLedgerTest do
  use DoubleEntryLedger.DataCase

  @default_ledger Ledger.default_casino_ledger()

  # user balance is a liability account
  # credit increase, debit decrease so debit must not exceed credits
  test "it should create a user balance liability account" do
    account_id = account_id_sequence()
    user_id = 333

    assert DoubleEntryLedger.create_account(
             account_id,
             Account.user_balance_liability_code(),
             user_id
           ) ==
             {:ok, []}

    assert {:ok, account} = DoubleEntryLedger.lookup_account(account_id)
    assert account.id == ID.from_int(account_id)
    assert account.ledger == @default_ledger
    assert account.code == Account.user_balance_liability_code()
    assert account.user_data_128 == <<user_id::128>>

    assert account.flags ==
             struct(TigerBeetlex.AccountFlags, %{debits_must_not_exceed_credits: true})
  end

  test "it should create a system revenue equity account" do
    account_id = account_id_sequence()

    assert DoubleEntryLedger.create_account(
             account_id,
             Account.system_revenue_equity_code()
           ) ==
             {:ok, []}

    assert {:ok, account} = DoubleEntryLedger.lookup_account(account_id)
    assert account.id == ID.from_int(account_id)
    assert account.ledger == @default_ledger
    assert account.code == Account.system_revenue_equity_code()
    assert account.user_data_128 == <<0::128>>

    assert account.flags == struct(TigerBeetlex.AccountFlags, %{})
  end

  test "it should create cash external asset account" do
    account_id = account_id_sequence()

    assert DoubleEntryLedger.create_account(
             account_id,
             Account.cash_external_asset_code()
           ) ==
             {:ok, []}

    assert {:ok, account} = DoubleEntryLedger.lookup_account(account_id)
    assert account.id == ID.from_int(account_id)
    assert account.ledger == @default_ledger
    assert account.code == Account.cash_external_asset_code()
    assert account.user_data_128 == <<0::128>>

    assert account.flags == struct(TigerBeetlex.AccountFlags, %{})
  end
end
