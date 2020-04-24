defmodule PowerDNSex do
  use Application

  alias PowerDNSex.{Server, Config, Models.Zone, Models.Error}

  @name :PowerDNSex

  def start(_, _), do: start()

  @spec start() :: GenServer.on_start()
  @doc false
  def start do
    children = [:poolboy.child_spec(:pool, pool_config())]
    options = [strategy: :one_for_one, name: :"#{@name}.Supervisor"]

    try do
      Config.valid?()

      case Supervisor.start_link(children, options) do
        {:ok, pid} -> {:ok, pid}
        {:error, {:already_started, pid}} -> {:ok, pid}
        other -> other
      end
    rescue
      error -> {:error, error}
    end
  end

  @default_server "localhost"

  #########
  # Zones #
  #########

  @spec create_zone(Zone.t(), String.t()) :: Zone.t() | Error.t()
  @doc """
  Create a new Zone on PowerDNS
  """
  def create_zone(%Zone{} = zone, server_name \\ @default_server) do
    call({:create_zone, zone, server_name})
  end

  @spec show_zone(String.t(), String.t()) :: :ok | {:error, String.t()}
  @doc """
  Show / Retrive info of the specific Zone
  """
  def show_zone(zone, server_name \\ @default_server) when is_binary(zone) do
    call({:show_zone, zone, server_name})
  end

  @spec delete_zone(String.t(), String.t()) :: :ok | {:error, String.t()}
  @doc """
  Delete specific Zone on PowerDNS
  """
  def delete_zone(zone, server_name \\ @default_server) when is_binary(zone) do
    call({:delete_zone, zone, server_name})
  end

  ###########
  # Records #
  ###########

  @spec create_record(Zone.t(), struct) :: :ok | {:error, String.t()}
  @doc """
  Create a new Record for the given Zone
  """
  def create_record(%Zone{} = zone, %{} = rrset_attrs) do
    call({:create_record, zone, rrset_attrs})
  end

  @spec show_record(String.t(), struct) :: :ok | {:error, String.t()}
  @doc """
  Show / Retrive info of the specific Record of the given Zone name
  """
  def show_record(zone_name, %{} = rrset_attrs) do
    call({:show_record, zone_name, rrset_attrs})
  end

  @spec update_record(Zone.t(), struct) :: :ok | {:error, String.t()}
  @doc """
  Update Record of the given Zone
  """
  def update_record(%Zone{} = zone, %{} = rrset_attrs) do
    call({:update_record, zone, rrset_attrs})
  end

  @spec delete_record(Zone.t(), struct) :: :ok | {:error, String.t()}
  @doc """
  Delete specific Record of given Zone
  """
  def delete_record(%Zone{} = zone, %{} = rrset_attrs) do
    call({:delete_record, zone, rrset_attrs})
  end

  ###########
  # Private #
  ###########

  defp pool_config do
    [
      name: {:local, @name},
      worker_module: Server,
      size: Application.get_env(:powerdnsex, :pool_size, 20),
      max_overflow: Application.get_env(:powerdnsex, :pool_overflow, 8)
    ]
  end

  defp call(params) do
    :poolboy.transaction(@name, fn pid ->
      GenServer.call(pid, params)
    end)
  end
end
