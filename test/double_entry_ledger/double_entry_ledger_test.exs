defmodule DoubleEntryLedgerTest do
  use DoubleEntryLedger.DataCase

  alias DoubleEntryLedger.AccountType
  alias TigerBeetlex.ID

  @test_ledger 999

  # user balance is a liability account
  # credit increase, debit decrease so debit must not exceed credits
  test "it should create a user balance liability account" do
    account_id = account_id_sequence()
    user_id = 333

    assert DoubleEntryLedger.create_account(
             account_id,
             @test_ledger,
             AccountType.user_balance_liability(),
             user_id
           ) ==
             {:ok, []}

    assert {:ok, account} = DoubleEntryLedger.lookup_account(account_id)
    assert account.id == ID.from_int(account_id)
    assert account.ledger == @test_ledger
    assert account.code == AccountType.user_balance_liability()
    assert account.user_data_128 == <<user_id::128>>

    assert account.flags ==
             struct(TigerBeetlex.AccountFlags, %{debits_must_not_exceed_credits: true})
  end

  test "it should create a system revenue equity account" do
    account_id = account_id_sequence()

    assert DoubleEntryLedger.create_account(
             account_id,
             @test_ledger,
             AccountType.system_revenue_equity()
           ) ==
             {:ok, []}

    assert {:ok, account} = DoubleEntryLedger.lookup_account(account_id)
    assert account.id == ID.from_int(account_id)
    assert account.ledger == @test_ledger
    assert account.code == AccountType.system_revenue_equity()
    assert account.user_data_128 == <<0::128>>

    assert account.flags == struct(TigerBeetlex.AccountFlags, %{})
  end

  test "it should create cash external asset account" do
    account_id = account_id_sequence()

    assert DoubleEntryLedger.create_account(
             account_id,
             @test_ledger,
             AccountType.cash_external_asset()
           ) ==
             {:ok, []}

    assert {:ok, account} = DoubleEntryLedger.lookup_account(account_id)
    assert account.id == ID.from_int(account_id)
    assert account.ledger == @test_ledger
    assert account.code == AccountType.cash_external_asset()
    assert account.user_data_128 == <<0::128>>

    assert account.flags == struct(TigerBeetlex.AccountFlags, %{})
  end
end
