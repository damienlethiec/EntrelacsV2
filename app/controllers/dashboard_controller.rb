class DashboardController < ApplicationController
  def index
    if current_user.admin?
      redirect_to stats_path
    elsif current_user.weaver? && current_user.residence.present?
      redirect_to residence_activities_path(current_user.residence)
    else
      # Weaver sans résidence - redirige vers les résidences (admin only, donc pas accessible)
      redirect_to residences_path
    end
  end
end
