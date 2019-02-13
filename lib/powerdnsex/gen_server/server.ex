defmodule PowerDNSex.Server do
  use GenServer

  alias PowerDNSex.Managers.{ZonesManager, RecordsManager}
  alias PowerDNSex.Converter

  def init(args) do
    {:ok, args}
  end

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  ###
  # Zones
  ###

  def handle_call({:create_zone, zone, server_name}, _from, state) do
    {:reply, ZonesManager.create(zone, server_name), state}
  end

  def handle_call({:show_zone, zone, server_name}, _from, state) do
    {:reply, ZonesManager.show(zone, server_name), state}
  end

  def handle_call({:delete_zone, zone, server_name}, _from, state) do
    {:reply, ZonesManager.delete(zone, server_name), state}
  end

  def handle_call({:create_record, zone, rrset_attrs}, _from, state) do
    attrs = Converter.keys_to_atom(rrset_attrs)
    {:reply, RecordsManager.create(zone, attrs), state}
  end

  def handle_call({:show_record, zone_name, rrset_attrs}, _from, state) do
    attrs = Converter.keys_to_atom(rrset_attrs)
    {:reply, RecordsManager.show(zone_name, attrs), state}
  end

  def handle_call({:update_record, zone, rrset_attrs}, _from, state) do
    attrs = Converter.keys_to_atom(rrset_attrs)
    {:reply, RecordsManager.update(zone, attrs), state}
  end

  def handle_call({:delete_record, zone, rrset_attrs}, _from, state) do
    {:reply, RecordsManager.delete(zone, rrset_attrs), state}
  end
end
