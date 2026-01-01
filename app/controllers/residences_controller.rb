class ResidencesController < ApplicationController
  before_action :set_residence, only: [:edit, :update, :destroy, :restore]

  def index
    @residences = policy_scope(Residence).order(:name)
    @residences = @residences.active unless params[:show_deleted] == "true" && current_user.admin?
  end

  def new
    @residence = Residence.new
    authorize @residence
  end

  def create
    @residence = Residence.new(residence_params)
    authorize @residence

    if @residence.save
      redirect_to residences_path, notice: t("flash.actions.create.success", resource_name: Residence.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @residence
  end

  def update
    authorize @residence

    if @residence.update(residence_params)
      redirect_to residences_path, notice: t("flash.actions.update.success", resource_name: Residence.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @residence
    @residence.soft_delete
    redirect_to residences_path, notice: t("flash.actions.destroy.success", resource_name: Residence.model_name.human)
  end

  def restore
    authorize @residence
    @residence.restore
    redirect_to residences_path, notice: t("residences.flash.restored")
  end

  private

  def set_residence
    @residence = Residence.find(params[:id])
  end

  def residence_params
    params.require(:residence).permit(:name, :address)
  end
end
