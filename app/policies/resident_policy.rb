class ResidentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

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

  def destroy?
    user_is_weaver_of_residence?
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
