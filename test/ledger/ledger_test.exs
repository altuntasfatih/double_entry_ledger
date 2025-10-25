defmodule LedgerTest do
  use LedgerTest.DataCase, async: false

  describe "create_user_account/3" do
    setup do
      _ = set_new_cash_asset_account()
      user_account_id = account_id_sequence()

      {:ok, user_account_id: user_account_id}
    end

    # user balance is a liability account
    # credit increase, debit decrease so debit must not exceed credits
    test "it should create a user balance liability account", %{
      user_account_id: user_account_id
    } do
      assert Ledger.create_user_account(user_account_id, user_account_id) == {:ok, []}

      assert {:ok, account} = Tigerbeetle.lookup_account(user_account_id)
      assert account.id == ID.from_int(user_account_id)
      assert account.ledger == default_casino_ledger_id()
      assert account.code == user_liability_code()
      assert account.user_data_128 == <<user_account_id::128>>
    end
  end

  describe "deposit_to_user_account/3" do
    setup do
      user_account_id = account_id_sequence()

      assert Ledger.create_user_account(user_account_id, user_account_id) == {:ok, []}

      {:ok, user_account_id: user_account_id, cash_asset_account_id: set_new_cash_asset_account()}
    end

    test "it should deposit to a user account", %{
      user_account_id: user_account_id,
      cash_asset_account_id: cash_asset_account_id
    } do
      # given
      amount = 100
      deposit_id = transaction_id_sequence()

      # when
      assert Ledger.deposit_to_user_account(deposit_id, user_account_id, amount) == :ok

      # credit for liability account
      assert {:ok,
              %{
                credits_posted: 100
              }} = Tigerbeetle.lookup_account(user_account_id)

      # debit for asset account
      assert {:ok,
              %{
                debits_posted: 100
              }} = Tigerbeetle.lookup_account(cash_asset_account_id)
    end
  end

  describe "withdraw_from_user_account/3" do
    setup do
      cash_asset_account_id = set_new_cash_asset_account()
      user_account_id = account_id_sequence()
      initial_deposit_amount = 100

      assert Ledger.create_user_account(user_account_id, user_account_id) == {:ok, []}

      assert Ledger.deposit_to_user_account(
               transaction_id_sequence(),
               user_account_id,
               initial_deposit_amount
             ) == :ok

      {:ok,
       user_account_id: user_account_id,
       initial_deposit_amount: initial_deposit_amount,
       cash_asset_account_id: cash_asset_account_id}
    end

    test "it should withdraw from a user account", %{
      user_account_id: user_account_id,
      initial_deposit_amount: initial_deposit_amount,
      cash_asset_account_id: cash_asset_account_id
    } do
      withdrawal_amount = 50
      withdrawal_id = transaction_id_sequence()

      assert Ledger.withdraw_from_user_account(withdrawal_id, user_account_id, withdrawal_amount) ==
               :ok

      assert {:ok,
              %{
                credits_posted: ^initial_deposit_amount,
                debits_posted: ^withdrawal_amount
              }} = Tigerbeetle.lookup_account(user_account_id)

      assert {:ok,
              %{
                debits_posted: ^initial_deposit_amount,
                credits_posted: ^withdrawal_amount
              }} = Tigerbeetle.lookup_account(cash_asset_account_id)
    end
  end
end
