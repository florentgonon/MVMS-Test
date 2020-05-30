class SecondReportingController < ApplicationController
  require 'csv'

  def index
    @client_list = client_list
    @orders_client = all_client_orders
  end

  ###################################### Méthodes pour retrouver le listing des commerçants ######################################

  def recover_clients_from_csv
    @all_clients = []

    CSV.foreach(Rails.root.join('lib/orders-testBON.csv'), encoding: 'iso-8859-1:utf-8', liberal_parsing: true) do |row|
      @all_clients << { client: row[0].to_s, merchant_name: row[10].to_s, fresh_product: row[19].to_i, necessary_product: row[20].to_i, secondary_product: row[21].to_i, delivery_mode: row[26].to_s }
    end
  end

  def all_client_name
    recover_clients_from_csv

    @all_clients_names = []

    @all_clients.each do |client|
      @all_clients_names << client[:client]
    end
    return @all_clients_names
  end

  def client_list
    all_client_name

    @client_list = @all_clients_names.uniq

    return @client_list
  end

  ###################################### Méthodes pour retrouver le nombre de commandes par commerçant ######################################

  def orders_client
    recover_clients_from_csv
    # return @all_clients
  end

  # def all_client_orders
  #   orders_client

  #   @numbers = []

  #   @all_clients.each do |client|
  #     @array = []
  #     @array << client[:fresh_product] << client[:necessary_product] << client[:secondary_product]
  #     @numbers << @array
  #   end

  #   return @numbers
  # end

  def all_client_orders
    orders_client

    @cclients = @all_clients.group_by { |client_name| client_name }.values
  end
end
