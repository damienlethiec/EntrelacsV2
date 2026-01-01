class ActivityPolicy < ApplicationPolicy
  # Everyone can view activities of all residences
  def index?
    true
  end

  def show?
    true
  end

  # Only weavers of the residence can manage activities
  def create?
    user_is_weaver_of_residence?
  end

  def new?
    create?
  end

  def update?
    user_is_weaver_of_residence?
  end

  def edit?
    update?
  end

  def cancel?
    user_is_weaver_of_residence? && record.planned?
  end

  def complete?
    user_is_weaver_of_residence? && record.completable?
  end

  private

  def user_is_weaver_of_residence?
    user.weaver? && user.residence_id == record.residence_id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
