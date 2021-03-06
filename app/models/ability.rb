class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new # guest user (not logged in)
    if user.manager?
      can :manage, :all
    end

    if user.staff?
      cannot :manage, MembershipRequest # This is management of the user-facing membership stuff
    end

    unless user.staff?
      can :create, MembershipRequest

      can :read, MembershipRequest, :user_id => user.id
      can :destroy, MembershipRequest, :user_id => user.id

      can :workflow_new, MembershipRequest, :user_id => user.id
      can :workflow_notify_pitching_night, :user_id => user.id
      can :workflow_book_interview, MembershipRequest, :user_id => user.id
      can :workflow_pending_decision, MembershipRequest, :user_id => user.id
      can :workflow_payment_required, MembershipRequest, :user_id => user.id
      can :workflow_active_membership, MembershipRequest, :user_id => user.id
      can :workflow_rejected, MembershipRequest, :user_id => user.id
      can :workflow_cancelled, MembershipRequest, :user_id => user.id
      can :workflow_expired, MembershipRequest, :user_id => user.id

      can :create, User
      can :read, User, :id => user.id
      can :update, User, :id => user.id
      can :dashboard, User, :id => user.id

      can :create, UserProfile
      can :read, UserProfile, :id => user.id
    end
  end
end
