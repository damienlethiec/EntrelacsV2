class DashboardController < ApplicationController
  def index
    # TODO: Phase 3/4 - Rediriger vers la bonne page selon le rôle
    # Admin → stats, Weaver → activities de sa résidence
    #
    # if current_user.admin?
    #   redirect_to stats_path
    # elsif current_user.weaver? && current_user.residence.present?
    #   redirect_to residence_activities_path(current_user.residence)
    # end
  end
end
