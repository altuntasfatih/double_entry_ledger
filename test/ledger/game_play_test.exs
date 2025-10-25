defmodule Ledger.GamePlayTest do
  use LedgerTest.DataCase, async: false

  describe "bet/4" do
    setup do
      _ = set_new_cash_asset_account()
      game_id = account_id_sequence()

      {:ok, user_account_id: create_user_account(), game_id: game_id}
    end

    test "it should bet on a game", %{
      user_account_id: user_account_id,
      game_id: game_id
    } do
      # given
      initial_balance = 100
      deposit_to_user_account(user_account_id, initial_balance)
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

    test "it should return an error if the user does not have enough balance", %{
      user_account_id: user_account_id,
      game_id: game_id
    } do
      # given
      bet_id = transaction_id_sequence()
      bet_amount = 1000

      # when
      assert {:error, :not_enough_balance} = GamePlay.bet(bet_id, user_account_id, game_id, bet_amount)
    end
  end
end
