defmodule DoubleEntryLedger.AccountType do
  @type account_type ::
          :cash_external_asset
          | :game_bet_pool_liability
          | :user_balance_liability
          | :system_revenue_equity
          | :system_capital_equity

  @code %{
    :cash_external_asset => 1,
    :game_bet_pool_liability => 2,
    :user_balance_liability => 3,
    :system_revenue_equity => 4,
    :system_capital_equity => 5
  }

  def cash_external_asset, do: @code[:cash_external_asset]
  def game_bet_pool_liability, do: @code[:game_bet_pool_liability]
  def user_balance_liability, do: @code[:user_balance_liability]
  def system_revenue_equity, do: @code[:system_revenue_equity]
  def system_capital_equity, do: @code[:system_capital_equity]
end
