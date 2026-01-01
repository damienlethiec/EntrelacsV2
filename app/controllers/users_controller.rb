class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    authorize User
    @users = policy_scope(User).includes(:residence).order(:last_name, :first_name)
  end

  def new
    authorize User
    @user = User.new
  end

  def create
    authorize User
    @user = User.invite!(user_params)

    if @user.errors.empty?
      redirect_to admin_users_path, notice: t("flash.actions.create.success", resource_name: User.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    if @user.update(user_params)
      redirect_to admin_users_path, notice: t("flash.actions.update.success", resource_name: User.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to admin_users_path, notice: t("flash.actions.destroy.success", resource_name: User.model_name.human)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :residence_id)
  end
end
