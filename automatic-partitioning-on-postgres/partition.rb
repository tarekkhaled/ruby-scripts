# frozen_string_literal: true

# This class handles automatic partitions on postgres

require 'pg'
class Partition
  attr_writer :partitions_number
  attr_reader :partition_tables, :partition_table_records_range, :table_name, :conn

  def initialize(**opts)
    @db_user = opts[:db_user]
    @db_pass = opts[:db_pass]
    @db_host = opts[:db_host] || 'localhost'
    @db_port = opts[:db_port] || 5432
    @db_name = opts[:db_name]
    @table_name = opts[:table_name]
    @partition_tables = []
    @conn = PG::Connection.new(@db_host, @db_port, nil, nil, @db_name, nil, @db_pass)
    @partition_table_records_range = opts[:partition_range]
  end

  def automate
    (0..partitions_number).each do |i|
      id_from = i * partition_table_records_range
      id_to = (i + 1) * partition_table_records_range
      name = generate_partition_table_name(id_from, id_to)
      create_partition_table(name)
      partition_tables << name
      attach_partition_table(name, id_from, id_to)
    end
  end

  private

  def partitions_number
    (table_records / partition_table_records_range).floor
  end

  def table_records
    1_000_000
  end

  def generate_partition_table_name(id_from, id_to)
    "#{table_name}_#{id_from}_#{id_to}"
  end

  def attach_partition_table(name, from_range, to_range)
    conn.exec("alter table #{table_name} attach partition #{name} for values from (#{from_range}) to (#{to_range})")
  end

  def create_partition_table(name)
    conn.exec("create table #{name} (like #{table_name} including indexes)")
  end
end
