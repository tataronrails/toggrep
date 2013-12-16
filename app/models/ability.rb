class Ability
  include CanCan::Ability

  attr_accessor :user

  def initialize(user = nil)
    @user = user ||= User.new
    change_aliases!
    all_users
    if user.new_record?
      public_user
    else
      signed_up_user
    end
    super_user if user.admin?
  end

  private

  def all_users
    cannot :manage, :all
  end

  def public_user
  end

  def signed_up_user
    can :read, User
    can :read_details, User, id: user.id
    can :change, User, id: user.id
  end

  def super_user
    can :access, :rails_admin
    can :manage, :all
  end

  def change_aliases!
    clear_aliased_actions
    alias_action :index, :show, :to => :read
    alias_action :new, :to => :create
    alias_action :edit, :to => :update
    alias_action :destroy, :to => :delete
    alias_action :update, :delete, :to => :change
    alias_action :create, :read, :change, :to => :manage
  end

end
