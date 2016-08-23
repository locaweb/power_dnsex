defmodule PowerDNSex do
  @default_server "localhost"
  use PowerDNSex.ServerSetup

  alias PowerDNSex.Managers.{ZonesManager, RecordsManager}
  alias PowerDNSex.Models.Zone

  ###
  # Zones
  ###

  @spec create_zone(Zone.t, String.t) :: :ok | {:error, String.t}
  @doc """
  Create a new Zone on PowerDNS
  """
  def create_zone(%Zone{} = zone, server_name \\ @default_server) do
    ZonesManager.create(zone, server_name)
  end

  @spec show_zone(Zone.t, String.t) :: :ok | {:error, String.t}
  @doc """
  Show / Retrive info of the specific Zone
  """
  def show_zone(%Zone{} = zone, server_name \\ @default_server) do
    ZonesManager.show(zone, server_name)
  end

  @spec delete_zone(Zone.t, String.t) :: :ok | {:error, String.t}
  @doc """
  Delete specific Zone on PowerDNS
  """
  def delete_zone(%Zone{} = zone, server_name \\ @default_server) do
    ZonesManager.delete(zone, server_name)
  end

  ###
  # Records
  ###
  @spec create_record(Zone.t, struct) :: :ok | {:error, String.t}
  @doc """
  Create a new Record for the given Zone
  """
  def create_record(%Zone{} = zone, %{} = rrset_attrs) do
    RecordsManager.create(zone, rrset_attrs)
  end

  @spec show_record(Zone.t, struct) :: :ok | {:error, String.t}
  @doc """
  Show / Retrive info of the specific Record of the given Zone
  """
  def show_record(%Zone{} = zone, %{} = rrset_attrs) do
    RecordsManager.show(zone, rrset_attrs)
  end

  @spec update_record(Zone.t, struct) :: :ok | {:error, String.t}
  @doc """
  Update Record of the given Zone
  """
  def update_record(%Zone{} = zone, %{} = rrset_attrs) do
    RecordsManager.update(zone, rrset_attrs)
  end

  @spec delete_record(Zone.t, struct) :: :ok | {:error, String.t}
  @doc """
  Delete specific Record of given Zone
  """
  def delete_record(%Zone{} = zone, %{} = rrset_attrs) do
    RecordsManager.delete(zone, rrset_attrs)
  end
end
