defmodule Ledger.Application do
  use Application

  @spec start(any(), any()) :: {:error, any()} | {:ok, pid()}
  def start(_type, _args) do
    children = [
      # it is a blocking api with N receiver partion supervisor
      {TigerBeetlex.Connection, tiger_beetle_config()}
    ]

    opts = [strategy: :one_for_one, name: Ledger.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp tiger_beetle_config do
    tiger_beetle_config = Application.get_env(:ledger, :tigerbeetlex, [])

    [
      addresses: Keyword.fetch!(tiger_beetle_config, :addresses),
      cluster_id: Keyword.fetch!(tiger_beetle_config, :cluster) |> TigerBeetlex.ID.from_int(),
      name: Keyword.fetch!(tiger_beetle_config, :connection_name)
    ]
  end
end
