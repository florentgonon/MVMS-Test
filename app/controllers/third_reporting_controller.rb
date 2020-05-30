class ThirdReportingController < ApplicationController
  require 'csv'

  def index
    @total_visit_april = april_visit
    @total_visit_may = may_visit
  end

  private

  def recover_visits_from_csv
    ## J'instancie un array vide ##
    @all_visits = []

    ## Je vais chercher le CSV puis j'itère dessus ##
    CSV.foreach(Rails.root.join('lib/data-test.csv'), encoding: 'iso-8859-1:utf-8', liberal_parsing: true) do |row|
      ## Je crée une instance pour chaque visite avec les infos du CSV, puis je l'insère dans l'array @all_visits ##
      @all_visits << { date: row[0], visit_associated: row[1].to_i }
    end
  end

  def sort_by_month
    ## J'appelle la méthode recover_visits_from_csv ##
    recover_visits_from_csv

    ## J'instancie un array vide ##
    @april_visits = []
    ## J'instancie un deuxième array vide ##
    @may_visits = []

    ## J'itère sur l'array @all_visits dans lequel se trouve toutes les instances de visites ##
    @all_visits.each do |visit|
      ## J'itère sur chaque instance ##
      visit.each do |key, value|
        ## Je crée une condition afin de trier les visites par mois : Soit avril soit mai ##
        case
        ## Si le quatrième caractère de la valeur courant est un 4, alors je pousse l'instance de la valeur courante dans l'array @april_visits qui stocke toutes les instances de visites effectuées en avril ##
        when value[4] == "4"
          then @april_visits << visit
        ## Si le quatrième caractère de la valeur courant est un 5, alors je pousse l'instance de la valeur courante dans l'array @may_visits qui stocke toutes les instances de visites effectuées en mai ##
        when value[4] == "5"
          then @may_visits << visit
        end
      end
    end
  end

  def april_visit
    ## J'appelle la méthode sort_by_month ##
    sort_by_month

    ## J'instance un array vide ##
    @total_april = []

    ## J'itère sur l'array @april_visits dans lequel se trouve toutes les instances de visites effectuées en avril ##
    @april_visits.each do |visit|
      ## Je récupère seulement le nombre de visite et je le pousse dans l'array @total_april ##
      @total_april << visit[:visit_associated]
    end

    ## Je retourne la somme de toutes les valeurs contenues dans l'array @total_april afin d'obtenir le nombre total de visite en avril ##
    return @total_april.sum
  end

  def may_visit
    ## J'appelle la méthode sort_by_month ##
    sort_by_month

    ## J'instance un array vide ##
    @total_may = []

    ## J'itère sur l'array @may_visits dans lequel se trouve toutes les instances de visites effectuées en mai ##
    @may_visits.each do |visit|
      ## Je récupère seulement le nombre de visite et je le pousse dans l'array @total_may ##
      @total_may << visit[:visit_associated]
    end

    ## Je retourne la somme de toutes les valeurs contenues dans l'array @total_may afin d'obtenir le nombre total de visite en mai ##
    return @total_may.sum
  end
end
