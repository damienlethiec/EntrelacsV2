class ActivityPolicy < ApplicationPolicy
  def index?
    user_has_access_to_residence?
  end

  def show?
    user_has_access_to_residence?
  end

  def create?
    user_has_access_to_residence?
  end

  def new?
    create?
  end

  def update?
    user_has_access_to_residence?
  end

  def edit?
    update?
  end

  def cancel?
    user_has_access_to_residence? && record.planned?
  end

  def complete?
    user_has_access_to_residence? && record.completable?
  end

  private

  def user_has_access_to_residence?
    user.admin? || user.residence_id == record.residence_id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(residence_id: user.residence_id)
      end
    end
  end
end
