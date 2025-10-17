defmodule DoubleEntryLedger.Tigerbeetle do
  alias TigerBeetlex.ID

  require Logger

  def create_account(id, ledger, code, flags \\ %{}, user_data_128 \\ 0) do
    accounts = [
      %TigerBeetlex.Account{
        id: ID.from_int(id),
        ledger: ledger,
        code: code,
        user_data_128: <<user_data_128::128>>,
        flags: struct(TigerBeetlex.AccountFlags, flags)
      }
    ]

    {:ok, stream} = TigerBeetlex.Connection.create_accounts(get_connection_name!(), accounts)

    answer = Enum.to_list(stream)

    case answer do
      [] -> {:ok, answer}
      reason -> {:error, reason}
    end
  end

  def create_transfer(t), do: create_transfers([t])

  def create_transfers([_] = transfers) do
    case TigerBeetlex.Connection.create_transfers(get_connection_name!(), transfers) do
      {:ok, []} -> {:ok, []}
      {:ok, errors} -> {:error, errors}
      {:error, error} -> {:error, error}
    end
  end

  def lookup_transfers(ids) do
    ids =
      Enum.map(ids, fn
        id when is_integer(id) -> <<id::128>>
        id -> id
      end)

    case TigerBeetlex.Connection.lookup_transfers(get_connection_name!(), ids) do
      {:ok, transfers} when transfers != [] -> {:ok, transfers}
      {:ok, []} -> {:error, :transfers_not_found}
      {:error, error} -> {:error, error}
    end
  end

  def lookup_account(id) when is_integer(id), do: lookup_accounts(ID.from_int(id))
  def lookup_account(id) when is_binary(id), do: lookup_accounts(id)

  defp lookup_accounts(id) do
    ids = [id]

    {:ok, stream_lookup} = TigerBeetlex.Connection.lookup_accounts(get_connection_name!(), ids)

    list = Enum.to_list(stream_lookup)

    case list do
      [%TigerBeetlex.Account{} = account] -> {:ok, account}
      _ -> {:error, :account_not_found}
    end
  end

  def query_accounts(ledger, code, user_data_128, limit \\ 100) do
    query_filter = %TigerBeetlex.QueryFilter{
      ledger: ledger,
      code: code,
      user_data_128: <<user_data_128::128>>,
      limit: limit
    }

    {:ok, stream_lookup} =
      TigerBeetlex.Connection.query_accounts(get_connection_name!(), query_filter)

    list = Enum.to_list(stream_lookup)

    case list do
      [%TigerBeetlex.Account{}] -> {:ok, list}
      _ -> {:error, :not_found}
    end
  end

  def health_check do
    case TigerBeetlex.Connection.query_accounts(get_connection_name!(), %TigerBeetlex.QueryFilter{
           limit: 1
         }) do
      {:ok, result} -> {:ok, Enum.to_list(result)}
      {:error, reason} -> {:error, inspect(reason)}
    end
  end

  defp get_connection_name!,
    do:
      Application.get_env(:double_entry_ledger, :tigerbeetlex, [])
      |> Keyword.fetch!(:connection_name)
end
