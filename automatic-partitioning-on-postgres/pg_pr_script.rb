# frozen_string_literal: true

require '../automatic-partitioning-on-postgres/partition'

puts 'Please Enter Database user ex(user1)'
db_user = gets.chomp
puts 'Please Enter Database password'
db_pass = gets.chomp
puts 'Please Enter Database name'
db_name = gets.chomp
puts 'Please Enter the table name that you want to partition'
table_name = gets.chomp
puts 'Please Enter number of records in each partition table'
partition_range = gets.chomp.to_i


ps = Partition.new(db_user: db_user, db_name: db_name, partition_range: partition_range, db_pass: db_pass, table_name: table_name)

puts 'Starting The partition operation'
ps.automate
puts "Here's the generated tables \n"
puts ps.partition_tables
