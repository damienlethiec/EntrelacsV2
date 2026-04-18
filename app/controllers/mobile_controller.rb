class MobileController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
    render json: {
      settings: {},
      rules: path_configuration_rules,
      tabs: tabs_for(current_user)
    }
  end

  private

  def path_configuration_rules
    [
      {
        patterns: ["/users/sign_in", "/users/password"],
        properties: {context: "modal", presentation: "replace_root"}
      },
      {
        patterns: ["/new$", "/edit$"],
        properties: {context: "modal", presentation: "pull"}
      },
      {
        patterns: ["^/$", "^/stats$", "^/residences$", "^/admin/users$"],
        properties: {presentation: "replace_root", pull_to_refresh_enabled: true}
      },
      {
        patterns: [".*"],
        properties: {presentation: "push", pull_to_refresh_enabled: true}
      }
    ]
  end

  def tabs_for(user)
    return [] unless user

    if user.admin?
      admin_tabs
    elsif user.weaver?
      weaver_tabs(user)
    else
      []
    end
  end

  def admin_tabs
    [
      {label: "Stats", path: "/stats", icon: "ic_bar_chart"},
      {label: "Résidences", path: "/residences", icon: "ic_home"},
      {label: "Utilisateurs", path: "/admin/users", icon: "ic_group"}
    ]
  end

  def weaver_tabs(user)
    home = {label: "Accueil", path: "/", icon: "ic_home"}
    return [home] if user.residence_id.blank?

    [
      home,
      {label: "Activités", path: "/residences/#{user.residence_id}/activities", icon: "ic_event"},
      {label: "Habitants", path: "/residences/#{user.residence_id}/residents", icon: "ic_person"}
    ]
  end
end
