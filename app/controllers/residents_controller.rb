class ResidentsController < ApplicationController
  before_action :set_residence
  before_action :set_resident, only: [:show, :edit, :update, :destroy]

  def index
    authorize Resident.new(residence: @residence)

    @residents = policy_scope(Resident).where(residence: @residence).order(:last_name, :first_name)
  end

  def show
    authorize @resident
  end

  def new
    @resident = @residence.residents.build
    authorize @resident
  end

  def create
    @resident = @residence.residents.build(resident_params)
    authorize @resident

    if @resident.save
      redirect_to residence_residents_path(@residence), notice: t("flash.actions.create.success", resource_name: Resident.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @resident
  end

  def update
    authorize @resident

    if @resident.update(resident_params)
      redirect_to residence_residents_path(@residence), notice: t("flash.actions.update.success", resource_name: Resident.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @resident

    @resident.destroy
    redirect_to residence_residents_path(@residence), notice: t("flash.actions.destroy.success", resource_name: Resident.model_name.human)
  end

  private

  def set_residence
    @residence = Residence.find(params[:residence_id])
  end

  def set_resident
    @resident = @residence.residents.find(params[:id])
  end

  def resident_params
    params.require(:resident).permit(:first_name, :last_name, :email, :phone, :apartment, :notes)
  end
end
