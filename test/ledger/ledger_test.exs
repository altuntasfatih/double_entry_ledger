defmodule LedgerTest do
  use LedgerTest.DataCase, async: false

  describe "create_user_account/3" do
    setup do
      _ = set_new_cash_asset_account()
      :ok
    end

    # user balance is a liability account
    # credit increase, debit decrease so debit must not exceed credits
    test "it should create a user balance liability account" do
      # given
      user_account_id = account_id_sequence()
      # when
      assert :ok = Ledger.create_user_account(user_account_id, user_account_id)
      # then
      assert {:ok, account} = Tigerbeetle.lookup_account(user_account_id)
      assert account.id == ID.from_int(user_account_id)
      assert account.ledger == default_casino_ledger_id()
      assert account.code == user_liability_code()
      assert account.user_data_128 == <<user_account_id::128>>
    end
  end

  describe "deposit_to_user_account/3" do
    setup do
      {:ok, user_account: create_user_account(), cash_asset_account: set_new_cash_asset_account()}
    end

    test "it should deposit to a user account", %{
      user_account: user_account,
      cash_asset_account: cash_asset_account
    } do
      # given
      amount = 100
      deposit_id = transaction_id_sequence()

      # when
      assert :ok = Ledger.deposit_to_user_account(deposit_id, user_account, amount)

      # then,credit for liability account
      assert {:ok,
              %{
                credits_posted: ^amount
              }} = Tigerbeetle.lookup_account(user_account)

      # debit for asset account
      assert {:ok,
              %{
                debits_posted: ^amount
              }} = Tigerbeetle.lookup_account(cash_asset_account)
    end
  end

  describe "withdraw_from_user_account/3" do
    setup do
      {:ok, user_account: create_user_account(), cash_asset_account: set_new_cash_asset_account()}
    end

    test "it should withdraw from a user account", %{
      user_account: user_account,
      cash_asset_account: cash_asset_account
    } do
      # given
      initial_deposit_amount = 100
      deposit_to_user_account(user_account, initial_deposit_amount)

      withdrawal_amount = 50

      # when
      assert :ok =
               Ledger.withdraw_from_user_account(
                 transaction_id_sequence(),
                 user_account,
                 withdrawal_amount
               )

      assert {:ok,
              %{
                credits_posted: ^initial_deposit_amount,
                debits_posted: ^withdrawal_amount
              }} = Tigerbeetle.lookup_account(user_account)

      assert {:ok,
              %{
                debits_posted: ^initial_deposit_amount,
                credits_posted: ^withdrawal_amount
              }} = Tigerbeetle.lookup_account(cash_asset_account)
    end
  end
end
