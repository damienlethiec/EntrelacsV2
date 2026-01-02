module ActivitiesHelper
  def activity_calendar_class(activity)
    case activity.status
    when "completed"
      "bg-green-100 text-green-800 hover:bg-green-200"
    when "canceled"
      "bg-red-100 text-red-800 hover:bg-red-200"
    else
      "bg-blue-100 text-blue-800 hover:bg-blue-200"
    end
  end
end
