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
      @all_visits << { date: row[0], visit_associated: row[1].to_s }
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

    @total_april = 0

    @april_visits.each do |visit|
      visit.each do |key, value|
        if key == :date
          @total_april += value.to_i
        end
      end
    end
    return @total_april
  end

  def may_visit
    sort_by_month

    @total_may = 0

    @may_visits.each do |visit|
      visit.each do |key, value|
        if key == :date
          @total_may += value.to_i
        end
      end
    end
    return @total_may
  end
end
