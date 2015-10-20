class Ability
  include CanCan::Ability

  def initialize(current_user)

    alias_action :create, :read, :update, :destroy, :to => :crud
    
    current_user ||= User.new
    
    can :read, current_user

    can :update, User, :id => current_user.id

    can :change_password?, User do |user|
        current_user.id == user.id
    end

    if current_user.admin?
      can :manage, :all
      
      cannot :create, RequisitionReport
      cannot :manage, Order
      cannot :manage, Shipment
      cannot :manage, ImportSurv
    end

    if current_user.site?

      can :create, RequisitionReport
      can :read, RequisitionReport
      # can :destroy, RequisitionReport

      can :create_from_requisition_report, Order
      can :create, Order
    end


    if current_user.data_entry? || current_user.data_entry_and_reviewer?
      can :manage, ImportSurv
      can :manage, SurvSite
      can :manage, SurvSiteCommodity

      can :crud, Order
      can :export, Order

      can :tab_order_line, Order
    end

    if current_user.reviewer? || current_user.data_entry_and_reviewer?
      can :index, Order
      can :review, Order
      can :export, Order

      can :approve, OrderLine
      can :reject, OrderLine
      can :approve_all, OrderLine
    end

    if current_user.ams?
      can :manage, Shipment
      can :create_shipment, :shipments
      can :manage, SmsLog
    end
    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #     can :read, Comment do |comment|
    #        comment.try(:user) == user || user.role? moderator
    #     end
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
  end
end
