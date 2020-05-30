class SecondReportingController < ApplicationController
  require 'csv'

  def index
    @client_list = client_list
    @orders_client = orders_client
  end

  ###################################### Méthodes pour retrouver le listing des commerçants ######################################

  def recover_clients_from_csv
    ## J'instancie un array vide ##
    @all_clients = []

    ## Je vais chercher le CSV puis j'itère dessus ##
    CSV.foreach(Rails.root.join('lib/orders-test.csv'), encoding: 'iso-8859-1:utf-8', liberal_parsing: true) do |row|
      ## Je crée une instance pour chaque client avec les infos du CSV, puis je l'insère dans l'array @all_clients ##
      @all_clients << { client: row[0].to_s, merchant_name: row[10].to_s, fresh_product: row[19].to_i, necessary_product: row[20].to_i, secondary_product: row[21].to_i, delivery_mode: row[26].to_s }
    end
  end

  def all_client_name
    ## J'appelle la méthode recover_clients_from_csv ##
    recover_clients_from_csv

    ## J'instancie un array vide ##
    @all_clients_names = []

    ## J'itère sur l'array @all_clients dans lequel se trouve toutes les instances de clients ##
    @all_clients.each do |client|
      ## Je récupère seulement le nom des clients et je les insères dans le tableau @all_clients_name ##
      @all_clients_names << client[:client]
    end
  end

  def client_list
    ## J'appelle la méthode all_client_name ##
    all_client_name

    ## Je déclare une variable dans laquelle je stocke le tableau @all_clients_name auquel j'applique la méthode .uniq qui permet de grouper les duplicatas ##
    @client_list = @all_clients_names.uniq

    ## Je retourne le tableau @client_list qui contient la liste des clients sans les duplicatas ##
    return @client_list
  end

  ###################################### Méthodes pour retrouver le nombre de commandes par commerçant ######################################

  def orders_client
    ## J'appelle la méthode all_client_name ##
    all_client_name

    ## J'instancie un array vide ##
    @client_and_orders = []
    ## J'instancie un autre array vide ##
    @orders_list = []

    ## Je déclare une variable dans laquelle je stocke les clients et le nombre de commandes associés. Ce block permet qu'à chaque fois qu'un nom de client revient, on lui ajoute 1 commande. @orders_by_customer est alors un simple array ##
    @orders_by_customer = @all_clients_names.inject(Hash.new(0)) { |total, client| total[client] += 1 ; total }

    ## J'itère sur l'array @orders_by_customers afin de pousser dans un nouvelle array (@client_and_orders) chaque client et commande associé sous forme d'array. @client_and_orders et donc un array d'array ##
    @orders_by_customer.each do |order|
      @client_and_orders << order
    end

    ## J'itère sur l'array @client_and_orders afin de pousser dans un nouvelle array (@orders_list) seulement le nombre de commande. Pour ca je supprime le nom du client ##
    @client_and_orders.each do |order|
      @orders_list << order.delete_at(1)
    end

    ## Je retourne le tableau @orders_list qui contient la liste du nombre de commande par clients, rangés dans l'ordre d'apparition des clients ##
    return @orders_list
  end
end
