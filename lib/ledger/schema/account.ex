defmodule Ledger.Schema.Account do
  @type account_type ::
          :cash_asset
          | :game_bet_pool_liability
          | :user_liability
          | :system_revenue_equity
          | :system_capital_equity

  @code %{
    :cash_asset => 10,
    :game_bet_pool_liability => 20,
    :user_liability => 30,
    :system_revenue_equity => 40,
    :system_capital_equity => 50
  }

  def cash_asset_code, do: @code[:cash_asset]
  def game_bet_pool_liability_code, do: @code[:game_bet_pool_liability]
  def user_liability_code, do: @code[:user_liability]
  def system_revenue_equity_code, do: @code[:system_revenue_equity]
  def system_capital_equity_code, do: @code[:system_capital_equity]
end
