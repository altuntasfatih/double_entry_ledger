defmodule DoubleEntryLedgerTest do
  use ExUnit.Case

  alias DoubleEntryLedger.AccountType
  alias TigerBeetlex.ID

  @test_ledger 999

  test "it should create a asset account" do
    account_id = 13
    wallet_id = 333

    assert DoubleEntryLedger.create_account(
             account_id,
             @test_ledger,
             AccountType.cash_external_asset(),
             %{
               debits_must_not_exceed_credits: true
             },
             wallet_id
           ) ==
             {:ok, []}

    assert {:ok, account} = DoubleEntryLedger.lookup_account(account_id)
    assert account.id == ID.from_int(account_id)
    assert account.ledger == @test_ledger
    assert account.code == AccountType.cash_external_asset()
    assert account.user_data_128 == <<wallet_id::128>>

    assert account.flags ==
             struct(TigerBeetlex.AccountFlags, %{debits_must_not_exceed_credits: true})
  end
end
