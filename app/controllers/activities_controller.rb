class ActivitiesController < ApplicationController
  include Pagy::Method

  before_action :set_residence
  before_action :set_activity, only: [:show, :edit, :update, :cancel, :complete]

  def index
    authorize Activity.new(residence: @residence)

    @activities = policy_scope(Activity).where(residence: @residence)
    @pending_completion = @activities.pending_completion if policy(Activity.new(residence: @residence)).create?

    # Filter by time period
    if params[:period] == "past"
      @activities = @activities.past
      @current_period = "past"
    else
      @activities = @activities.upcoming
      @current_period = "upcoming"
    end

    # Filter by activity type
    if params[:activity_type].present?
      @activities = @activities.where(activity_type: params[:activity_type])
    end

    # Search by description
    if params[:search].present?
      @activities = @activities.where("description ILIKE ?", "%#{params[:search]}%")
    end

    # View mode (list or calendar)
    @view_mode = params[:view].presence || "list"

    # For calendar view, get activities for the current month
    if @view_mode == "calendar"
      @calendar_month = params[:month].present? ? Date.parse(params[:month]) : Date.current.beginning_of_month
      @calendar_activities = @residence.activities
        .where(starts_at: @calendar_month.beginning_of_month.beginning_of_week..@calendar_month.end_of_month.end_of_week)
        .order(starts_at: :asc)
    else
      # Pagination for list view
      @pagy, @activities = pagy(@activities, limit: 10)
    end

    @stats = calculate_stats
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

  def calculate_stats
    completed_activities = @residence.activities.completed_in_period(30.days.ago, Time.current)
    {
      completed_count: completed_activities.count,
      participants_count: completed_activities.sum(:participants_count)
    }
  end
end
