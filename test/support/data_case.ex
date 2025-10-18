defmodule LedgerTest.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Ledger.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Ledger.Schema.Account
      alias Ledger.Schema.CasinoLedger
      alias Ledger.Tigerbeetle
      alias TigerBeetlex.ID

      import LedgerTest.DataCase
      import LedgerTest.Factory
    end
  end
end
