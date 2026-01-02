class ActivitiesController < ApplicationController
  include Pagy::Method

  before_action :set_residence
  before_action :set_activity, only: [:show, :edit, :update, :cancel, :complete]

  def index
    authorize Activity.new(residence: @residence)

    @activities = filtered_activities
    @pending_completion = pending_activities if can_create_activity?
    @view_mode = params[:view].presence || "list"
    @current_period = (params[:period] == "past") ? "past" : "upcoming"

    if calendar_view?
      setup_calendar_view
    else
      @pagy, @activities = pagy(@activities, limit: 10)
    end

    @stats = @residence.activities.recent_stats
    @activity_types = @residence.activities.distinct.pluck(:activity_type).sort
  end

  def show
    authorize @activity
  end

  def new
    @activity = @residence.activities.build
    authorize @activity
  end

  def create
    @activity = @residence.activities.build(activity_params)
    authorize @activity

    if @activity.recurring?
      create_recurring_activities
    else
      create_single_activity
    end
  end

  def edit
    authorize @activity
  end

  def update
    authorize @activity

    if @activity.update(activity_params)
      redirect_to residence_activities_path(@residence), notice: t("flash.actions.update.success", resource_name: Activity.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    authorize @activity

    if @activity.cancel!
      redirect_to residence_activities_path(@residence), notice: t("activities.flash.canceled")
    else
      redirect_to residence_activities_path(@residence), alert: t("activities.flash.cannot_cancel")
    end
  end

  def complete
    authorize @activity

    if @activity.complete!(review: params[:review], participants_count: params[:participants_count].to_i)
      redirect_to residence_activities_path(@residence), notice: t("activities.flash.completed")
    else
      redirect_to residence_activities_path(@residence), alert: t("activities.flash.cannot_complete")
    end
  end

  private

  def set_residence
    @residence = Residence.find(params[:residence_id])
  end

  def set_activity
    @activity = @residence.activities.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:activity_type, :description, :starts_at, :ends_at, :notify_residents,
      :recurring, :recurrence_end_date, :recurrence_frequency)
  end

  def filtered_activities
    scope = policy_scope(Activity).where(residence: @residence)
    scope = (params[:period] == "past") ? scope.past : scope.upcoming
    scope = scope.by_type(params[:activity_type])
    scope.search(params[:search])
  end

  def pending_activities
    policy_scope(Activity).where(residence: @residence).pending_completion
  end

  def can_create_activity?
    policy(Activity.new(residence: @residence)).create?
  end

  def calendar_view?
    @view_mode == "calendar"
  end

  def setup_calendar_view
    @calendar_month = params[:month].present? ? Date.parse(params[:month]) : Date.current.beginning_of_month
    @calendar_activities = @residence.activities.for_calendar(@calendar_month)
  end

  def create_single_activity
    if @activity.save
      redirect_to residence_activities_path(@residence), notice: t("flash.actions.create.success", resource_name: Activity.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_recurring_activities
    occurrences = @activity.generate_occurrences

    if occurrences.empty?
      render :new, status: :unprocessable_entity
      return
    end

    Activity.transaction do
      occurrences.each(&:save!)
    end

    redirect_to residence_activities_path(@residence),
      notice: t("activities.flash.recurring_created", count: occurrences.size)
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end
end
