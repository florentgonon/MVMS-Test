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

    ## J'itère sur l'array @all_clients dans lequel se trouve toutes les instance de clients ##
    @all_clients.each do |client|
      ## Je récupère seulement le nom des clients et je les insères dans le tableau @all_clients_name ##
      @all_clients_names << client[:client]
    end
  end

  def uniq_client
    ## J'appelle la méthode all_client_name ##
    all_client_name

    ## Je déclare une variable dans laquelle je stocke le tableau @all_clients_name auquel j'applique la méthode .group_by afin de grouper les clients possédant un/des duplicatas par noms. Par exemple, le client "Les culottés" revient 6 fois, il ya donc un array avec 6 fois "Les culottés" à l'intérieur ##
    @clients_groupby_name = @all_clients_names.group_by { |client_name| client_name }.values

    ## J'instancie un array vide ##
    @uniq_client = []

    ## J'itère sur l'array @clients_groupby_name ##
    @clients_groupby_name.each do |client|
      ## Je crée une condition afin de trier les clients dans le but de ne garder que ceux dont l'array possède uniquement 1 élément (1 commande) : ##
      ## Si le client courant possède seulement 1 élément dans son array, alors je le pousse dans le nouvel array (@uniq_client) ##
      if client.size == 1
        @uniq_client << client
      end
    end

    ## Je retourne la taille de l'array @uniq_client afin d'obtenur le nombre de clients uniques ##
    return @uniq_client.size
  end

  ###################################### Méthodes pour retrouver le nombre de commandes ######################################

  def number_of_orders
    ## J'appelle la méthode recover_clients_from_csv ##
    recover_clients_from_csv

    ## Je retourne la taille de l'array @all_clients afin d'obtenir le nombre de commande ##
    return @all_clients.size
  end

  ###################################### Méthodes pour retrouver toutes les livraisons ######################################

  def all_deliveries
    ## J'appelle la méthode recover_clients_from_csv ##
    recover_clients_from_csv

    ## J'instancie un array vide ##
    @all_deliveries = []

    ## J'itère sur l'array @all_clients afin de retrouver toutes les livraisons ##
    @all_clients.each do |client|
      @all_deliveries << client[:delivery_mode]
    end
  end

  ###################################### Méthodes pour retrouver le nombre de livraison click and collect ######################################

  def click_and_collect_delivery
    ## J'appelle la méthode all_deliveries ##
    all_deliveries

    ## J'instancie un array vide ##
    @click_and_collect_delivery = []
    ## Je déclare une variable dans laquelle je stocke la string ci-dessous ##
    @click_and_collect = "Click & Collect"

    ## J'itère sur l'array @all_deliveries afin de retrouver toutes les livraisons Clock & Collect ##
    @all_deliveries.each do |delivery|
      ## Je crée une condition afin de trier les livraisons dans le but de ne garder que celles effectuées en Click & Collect : ##
      ## Si la livraison courante est strictement égale à la variable stockant la string "Click & collect", alors je la pousse dans le nouvel array (@click_and_collect_delivery) ##
      ## La méthode casecmp permet d'être insensible à la casse ##
      if delivery.casecmp(@click_and_collect) == 0
        @click_and_collect_delivery << delivery
      end
    end

    ## Je retourne la taille de l'array @click_and_collect_delivery afin d'obtenir le nombre de livrasion Click & Collect ##
    return @click_and_collect_delivery.size
  end

  ###################################### Méthode pour retrouver le nombre de livraison commerçant ######################################

  def merchant_delivery
    ## J'appelle la méthode all_deliveries ##
    all_deliveries

    ## J'instancie un array vide ##
    @merchant_delivery = []
    ## Je déclare une variable dans laquelle je stocke la string ci-dessous ##
    @merchant = "Livraison par le commercant"

    ## J'itère sur l'array @all_deliveries afin de retrouver toutes les livraisons par le commercant ##
    @all_deliveries.each do |delivery|
      ## Je crée une condition afin de trier les livraisons dans le but de ne garder que celles effectuées par le commercant : ##
      ## Si la livraison courante est strictement égale à la variable stockant la string "Livraison par le commercant", alors je la pousse dans le nouvel array (@merchant_delivery) ##
      ## La méthode casecmp permet d'être insensible à la casse ##
      if delivery.casecmp(@merchant) == 0
        @merchant_delivery << delivery
      end
    end

    ## Je retourne la taille de l'array @merchant_delivery afin d'obtenir le nombre de livrasion par le commercant ##
    return @merchant_delivery.size
  end

  ###################################### Méthode pour retrouver le nombre de livraison laposte ######################################

  def laposte_delivery
    ## J'appelle la méthode all_deliveries ##
    all_deliveries

    ## J'instancie un array vide ##
    @laposte_delivery = []
    ## Je déclare une variable dans laquelle je stocke la string ci-dessous ##
    @laposte = "Livraison laposte"

    ## J'itère sur l'array @all_deliveries afin de retrouver toutes les livraisons par laposte ##
    @all_deliveries.each do |delivery|
      ## Je crée une condition afin de trier les livraisons dans le but de ne garder que celles effectuées par la poste : ##
      ## Si la livraison courante est strictement égale à la variable stockant la string "Livraison laposte", alors je la pousse dans le nouvel array (@laposte_delivery) ##
      ## La méthode casecmp permet d'être insensible à la casse ##
      if delivery.casecmp(@laposte) == 0
        @laposte_delivery << delivery
      end
    end

    ## Je retourne la taille de l'array @laposte_delivery afin d'obtenir le nombre de livrasion par laposte ##
    return @laposte_delivery.size
  end
end
