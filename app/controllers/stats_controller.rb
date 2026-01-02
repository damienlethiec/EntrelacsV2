class StatsController < ApplicationController
  before_action :set_date_range
  before_action :set_residence, only: :show

  def index
    authorize :stats

    @residences = Residence.active.includes(:activities).order(:name)
    @activities = Activity.completed_in_period(@start_date, @end_date)

    setup_stats(global: true)

    respond_to do |format|
      format.html
      format.csv { send_data StatsCsvExporter.new(@activities).generate, filename: csv_filename }
    end
  end

  def show
    authorize :stats

    @activities = @residence.activities.completed_in_period(@start_date, @end_date)

    setup_stats(global: false)

    respond_to do |format|
      format.html
      format.csv { send_data StatsCsvExporter.new(@activities).generate, filename: csv_filename }
    end
  end

  private

  def set_date_range
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : 30.days.ago.to_date
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current
  rescue ArgumentError
    @start_date = 30.days.ago.to_date
    @end_date = Date.current
  end

  def set_residence
    @residence = Residence.find(params[:id])
  end

  def setup_stats(global:)
    calculator = StatsCalculator.new(@activities)

    @total_activities = calculator.total_activities
    @total_participants = calculator.total_participants
    @average_participants = calculator.average_participants
    @median_participants = calculator.median_participants
    @most_popular_type = calculator.most_popular_type

    @active_residences = calculator.active_residences_count if global

    @by_type = calculator.by_type
    @participants_by_type = calculator.participants_by_type
    @by_day_of_week = calculator.by_day_of_week
    @participants_by_day = calculator.participants_by_day
    @by_time_of_day = calculator.by_time_of_day
    @participants_by_time = calculator.participants_by_time
  end

  def csv_filename
    base = @residence ? "statistiques-#{@residence.name.parameterize}" : "statistiques-globales"
    "#{base}-#{Date.current}.csv"
  end
end
