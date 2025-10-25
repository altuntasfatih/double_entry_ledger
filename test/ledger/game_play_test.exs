defmodule Ledger.GamePlayTest do
  use LedgerTest.DataCase, async: false

  describe "bet/4" do
    setup do
      _ = set_new_cash_asset_account()
      user_account_id = account_id_sequence()
      game_id = account_id_sequence()
      initial_balance = 100

      assert {:ok, []} = Ledger.create_user_account(user_account_id, user_account_id)

      assert :ok =
               Ledger.deposit_to_user_account(
                 transaction_id_sequence(),
                 user_account_id,
                 initial_balance
               )

      {:ok, user_account_id: user_account_id, game_id: game_id, initial_balance: initial_balance}
    end

    test "it should bet on a game", %{
      user_account_id: user_account_id,
      game_id: game_id,
      initial_balance: initial_balance
    } do
      # given
      bet_id = transaction_id_sequence()
      bet_amount = 10

      # when
      assert :ok = GamePlay.bet(bet_id, user_account_id, game_id, bet_amount)

      # then
      assert {:ok,
              %{
                credits_posted: ^initial_balance,
                debits_posted: ^bet_amount
              }} = Tigerbeetle.lookup_account(user_account_id)

      assert {:ok,
              %{
                debits_posted: 0,
                credits_posted: ^bet_amount
              }} = Tigerbeetle.lookup_account(game_id)
    end
  end
end
