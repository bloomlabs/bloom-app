class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.manager?
      can :access, :rails_admin
      can :dashboard

      can :index, :all
      can :history, :all
      can :show, :all

      can :accept, MembershipRequest
      can :reject, MembershipRequest
      can :edit, User
    end

    if user.superuser?
      can :access, :rails_admin
      can :manage, :all
      cannot :show_in_app, :all
    end
  end
end
