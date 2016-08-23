defmodule PowerDNSex.ServerSetup do
  defmacro __using__(opts \\ []) do
    quote bind_quoted: [opts: opts] do
      use Application

      @name opts[:process_name] || :PowerDNSex
      @config opts[:config]

      @spec start(term, term) :: GenServer.on_start
      def start(_, _), do: start

      @spec start() :: GenServer.on_start
      @doc false
      def start do
        import Supervisor.Spec

        children = [worker(Server, [@name, @config])]

        options = [strategy: :one_for_one, name: :"#{@name}.Supervisor"]

        case Supervisor.start_link(children, options) do
          {:ok, pid} -> {:ok, pid}
          {:error, {:already_started, pid}} -> {:ok, pid}
          other -> other
        end
      end
    end
  end
end
