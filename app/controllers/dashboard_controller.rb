class DashboardController < ApplicationController
  def index
    if current_user.weaver? && current_user.residence.present?
      redirect_to residence_activities_path(current_user.residence)
    end
    # TODO: Phase Stats - Admin → stats_path
  end
end
