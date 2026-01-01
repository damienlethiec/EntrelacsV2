class ActivitiesController < ApplicationController
  before_action :set_residence
  before_action :set_activity, only: [:show, :edit, :update, :cancel, :complete]

  def index
    authorize Activity.new(residence: @residence)

    @activities = policy_scope(Activity).where(residence: @residence)

    if params[:past] == "true"
      @activities = @activities.past
      @showing_past = true
    else
      @pending_completion = @activities.pending_completion if policy(Activity.new(residence: @residence)).create?
      @activities = @activities.upcoming
      @showing_past = false
    end

    @stats = calculate_stats
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

    if @activity.save
      redirect_to residence_activities_path(@residence), notice: t("flash.actions.create.success", resource_name: Activity.model_name.human)
    else
      render :new, status: :unprocessable_entity
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
    params.require(:activity).permit(:activity_type, :description, :starts_at, :ends_at, :notify_residents)
  end

  def calculate_stats
    completed_activities = @residence.activities.completed_in_period(30.days.ago, Time.current)
    {
      completed_count: completed_activities.count,
      participants_count: completed_activities.sum(:participants_count)
    }
  end
end
