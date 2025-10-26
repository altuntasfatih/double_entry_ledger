defmodule GamePlay do
  def bet(user_account_id, game_account_id, bet_amount) do
    Ledger.bet_on_game(user_account_id, game_account_id, bet_amount)
  end

  def win(bet_id, win_amount) do
    Ledger.win_on_game(bet_id, win_amount)
  end

  def loss(_bet_id) do
    # Ledger.win_on_game(bet_id, amount)
  end

  # def loss_by_bet(loss_id, wallet_id, game_id, bet_id) do
  #   Ledger.loss_by_bet(loss_id, wallet_id, game_id, bet_id)
  # end
end
