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
      bet_amount = 10
      deposit_to_user_account(user_account_id, initial_balance)

      # when
      assert {:ok, _bet_id} = GamePlay.bet(user_account_id, game_id, bet_amount)

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
      bet_amount = 1000

      # when
      assert {:error, :not_enough_balance} =
               GamePlay.bet(user_account_id, game_id, bet_amount)
    end
  end

  describe "win/4" do
    setup do
      {:ok,
       user_account_id: create_user_account(),
       game_account_id: account_id_sequence(),
       cash_asset_account_id: set_new_cash_asset_account()}
    end

    test "it should win on a game", %{
      user_account_id: user_account_id,
      game_account_id: game_account_id,
      cash_asset_account_id: cash_asset_account_id
    } do
      # given
      initial_balance = 100
      bet_amount = 20
      win_amount = 50
      deposit_to_user_account(user_account_id, initial_balance)
      bet_id = bet_on_game(user_account_id, game_account_id, bet_amount)
      assert :ok = GamePlay.win(bet_id, win_amount)



      assert {:ok,
              %{
                debits_posted: 0,
                credits_posted: ^win_amount
              }} = Tigerbeetle.lookup_account(cash_asset_account_id)


              assert {:ok,
              %{
                debits_posted: 0,
                credits_posted: ^bet_amount
              }} = Tigerbeetle.lookup_account(game_account_id)
    end
  end
end
