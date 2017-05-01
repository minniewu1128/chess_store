class Ability
  include CanCan::Ability

  def initialize(user)
 
    # Define abilities for the passed in user here. For example:
    #have to raise exceptions: assert raise exception
    # only difference: customers can see only their own orders, won't see inventory count (don't use CanCan) (put in view, unless role? :admin || role? :manager)
    # CanCan cannot restrict authorization to specific fields

    user ||= User.new # guest user (not logged in)
    if user.role? :admin
        can :manage, :all
    
    elsif user.role? :manager
        #managers cannot edit customers, complete access to employees, only read access to customers
        can :read, :all
        #how to write read emmployee data
        #can do all three things same as manage?
        can :manage, Item
        can [:create, :update, :read], User do |u|
            !u.role? :customer
        end

        can :read, ItemPrice

        can :create, ItemPrice  do |item_price|
            all_items = Items.all.map(&:id)
            all_items.include? item_price.item.id
        
        end
        can :manage, Purchase

    elsif user.role? :shipper
        #can read personal information, edit name, phone, email and password (cannot edit username)
        can :read, Item

        can :index, Item

        can :index_pieces, Item

        can :index_boards, Item

        can :index_clocks, Item

        can :index_supplies, Item

        can :read, Order

        can :read, OrderItem

        can :update, OrderItem

        can :update, User do |u|
            u.id == user.id
        end

    elsif user.role? :customer


        can :index_pieces, Item

        can :index_boards, Item

        can :index_clocks, Item

        can :index_supplies, Item
        can :read, Item
        can :index, Item

        can :update, User do |u|
            u.id == user.id
        end

        can :index, Order do |o|

            #can do this in controller
            # if user.role? :customer
            # @order.user.orders.chronological.to_a
            # else @order =  Order.all
            #unless you are a customer, @orders should be all orders (order index page automicaly filters out for them)
            user_orders = user.orders.all.map(&:id)
            user_orders.include? o
        end

        can :index, OrderItem do |oi|

        end

        
        can :create, Order
        can :destroy, Order do |o|
            all_orders = Order.all.map(&:id)
            all_orders.include? o
        end

    else

        can :index, Item

        can :index_pieces, Item

        can :index_boards, Item

        can :index_clocks, Item

        can :index_supplies, Item

        can :read, Item
        
        can :create, User

        can :create, School


        
    end
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
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
