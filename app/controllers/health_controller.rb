# frozen_string_literal: true

class HealthController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    database_ok = database_connected?
    status = database_ok ? :ok : :service_unavailable

    render json: {
      status: database_ok ? "healthy" : "unhealthy",
      database: database_ok,
      version: Rails.application.class.module_parent_name,
      timestamp: Time.current.iso8601
    }, status: status
  end

  private

  def database_connected?
    ActiveRecord::Base.connection.execute("SELECT 1")
    true
  rescue StandardError
    false
  end
end
