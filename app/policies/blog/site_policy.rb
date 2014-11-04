class Blog::SitePolicy < ApplicationPolicy
  def index?
    !!user
  end

  def show?
    record.user == user
  end

  def create?
    !!user
  end

  def new?
    create?
  end

  def update?
    record.user == user
  end

  def edit?
    update?
  end

  def destroy?
    record.user == user
  end

  class Scope < Scope
    def resolve
      # Blog::Site.where(user_id: user.id)で絞り込みます
      scope.where(user_id: user.id)
    end
  end
end
