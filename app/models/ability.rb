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
    can :create, Agreement
    can :read, Agreement,
      ['worker_id = ? or manager_id = ?', user.id, user.id] do |agreement|
      agreement.worker == user || agreement.manager == user
    end
    can :update, Agreement do |agreement|
      agreement.can_be_changed_by_user?(user)
    end
    can :accept, Agreement do |agreement|
      agreement.can_be_accepted_by_user?(user)
    end
    can :reject, Agreement do |agreement|
      agreement.can_be_rejected_by_user?(user)
    end
    can :cancel, Agreement do |agreement|
      agreement.can_be_canceled_by_user?(user)
    end

  end

  def super_user
    can :access, :rails_admin
    can :manage, :crud
    can :dashboard
    can :crud, ViolationRule
  end

  def change_aliases!
    clear_aliased_actions
    alias_action :index, :show, :to => :read
    alias_action :new, :to => :create
    alias_action :edit, :to => :update
    alias_action :destroy, :to => :delete
    alias_action :update, :delete, :to => :change
    alias_action :create, :read, :change, :to => :crud
  end

end
