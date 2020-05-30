class ThirdReportingController < ApplicationController
  require 'csv'

  def index
    @total_visit_april = april_visit
    @total_visit_may = may_visit
  end

  private

  def recover_visits_from_csv
    @all_visits = []

    CSV.foreach(Rails.root.join('lib/data-test.csv'), encoding: 'iso-8859-1:utf-8', liberal_parsing: true) do |row|
      @all_visits << { date: row[0], visit_associated: row[1].to_i }
    end
    # return @all_visits
  end

  def sort_by_month
    recover_visits_from_csv

    @april_visits = []
    @may_visits = []

    @all_visits.each do |visit|
      visit.each do |key, value|
        case
        when value[4] == "4"
          then @april_visits << visit
        when value[4] == "5"
          then @may_visits << visit
        end
      end
    end
  end

  def april_visit
    sort_by_month

    @total_april = []

    @april_visits.each do |visit|
      @total_april << visit[:visit_associated]
    end
    return @total_april.sum
  end

  def may_visit
    sort_by_month

    @total_may = []

    @may_visits.each do |visit|
      @total_may << visit[:visit_associated]
    end
    return @total_may.sum
  end
end
