defmodule GamePlay do
  def bet(bet_id, wallet_id, game_id, amount) do
    Ledger.bet_on_game(bet_id, wallet_id, game_id, amount)
  end

  # def win(win_id, wallet_id, game_id, amount) do
  #   Ledger.win_on_game(tx_id, wallet_id, game_id, amount)
  # end

  # def loss(tx_id, wallet_id, game_id, amount) do
  #   Ledger.loss_on_game(tx_id, wallet_id, game_id, amount)
  # end
end
