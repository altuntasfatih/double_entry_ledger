defmodule Ledger.Schema.Account do
  @type account_type ::
          :cash_external_asset
          | :game_bet_pool_liability
          | :user_balance_liability
          | :system_revenue_equity
          | :system_capital_equity

  @code %{
    :cash_external_asset => 10,
    :game_bet_pool_liability => 20,
    :user_balance_liability => 30,
    :system_revenue_equity => 40,
    :system_capital_equity => 50
  }

  @static_account_ids %{
    :cash_external_asset => 1,
    :system_revenue_equity => 2,
    :system_capital_equity => 3
  }

  def cash_external_asset_code, do: @code[:cash_external_asset]
  def game_bet_pool_liability_code, do: @code[:game_bet_pool_liability]
  def user_balance_liability_code, do: @code[:user_balance_liability]
  def system_revenue_equity_code, do: @code[:system_revenue_equity]
  def system_capital_equity_code, do: @code[:system_capital_equity]

  def static_account_ids(type), do: @static_account_ids[type]
end
