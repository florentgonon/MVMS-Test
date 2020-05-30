class FirstReportingController < ApplicationController
  require 'csv'

  def index
    @uniq_client = uniq_client
    @order = number_of_orders
    @click_and_collect_delivery = click_and_collect_delivery
    @merchant_delivery = merchant_delivery
    @laposte_delivery = laposte_delivery

  end

  private

  ###################################### Méthodes pour retrouver le nombre de clients uniques ######################################

  def recover_clients_from_csv
    @all_clients = []

    CSV.foreach(Rails.root.join('lib/orders-test.csv'), encoding: 'iso-8859-1:utf-8') do |row|
      @all_clients << { client: row[0].to_s, merchant_name: row[1].to_s, fresh_product: row[2].to_i, necessary_product: row[3].to_i, secondary_product: row[4].to_i, delivery_mode: row[5].to_s }
    end
    #return @all_clients.size
  end

  def all_client_name
    recover_clients_from_csv

    @all_clients_names = []

    @all_clients.each do |client|
      @all_clients_names << client[:client]
    end
  end

  def uniq_client
    all_client_name

    @clients_groupby_name = @all_clients_names.group_by { |client_name| client_name }.values

    @uniq_client = []

    @clients_groupby_name.each do |client|
      if client.size == 1
        @uniq_client << client
      end
    end
    return @uniq_client.size
  end

  ###################################### Méthodes pour retrouver le nombre de commandes ######################################

  def number_of_orders
    recover_clients_from_csv
    return @all_clients.size
  end

  ###################################### Méthodes pour retrouver toutes les livraisons ######################################

  def all_deliveries
    recover_clients_from_csv

    @all_deliveries = []

    @all_clients.each do |client|
      @all_deliveries << client[:delivery_mode]
    end
  end

  ###################################### Méthodes pour retrouver le nombre de livraison click and collect ######################################

  def click_and_collect_delivery
    all_deliveries

    @click_and_collect_delivery = []
    @click_and_collect = "Click & Collect"

    @all_deliveries.each do |delivery|
      if delivery.casecmp(@click_and_collect) == 0
        @click_and_collect_delivery << delivery
      end
    end
    return @click_and_collect_delivery.size
  end

  ###################################### Méthode pour retrouver le nombre de livraison commerçant ######################################

  def merchant_delivery
    all_deliveries

    @merchant_delivery = []
    @merchant = "Livraison par le commerçant"

    @all_deliveries.each do |delivery|
      if delivery.casecmp(@merchant) == 0
        @merchant_delivery << delivery
      end
    end
    return @merchant_delivery.size
  end

  ###################################### Méthode pour retrouver le nombre de livraison laposte ######################################

  def laposte_delivery
    all_deliveries

    @laposte_delivery = []
    @laposte = "Livraison laposte"

    @all_deliveries.each do |delivery|
      if delivery.casecmp(@laposte) == 0
        @laposte_delivery << delivery
      end
    end
    return @laposte_delivery.size
  end
end
