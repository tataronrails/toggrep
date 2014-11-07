class AgreementsController < ResourcesController

  belongs_to :user, optional: true

  ( Agreement::FILTERS - %w(all) ).each do |filter|
    has_scope filter.to_sym, type: :boolean
  end

  before_filter :set_manager, only: :create
  before_filter :set_default_attributes, only: :new
  after_filter :notify_worker, only: :create
  after_filter :update_state, only: :update

  def accept
    resource.accept
    redirect_to resource
  end

  def reject
    resource.reject
    redirect_to resource
  end

  def cancel
    resource.cancel
    redirect_to resource
  end

  def show
    @time_entries = TogglProject.time_entries(@agreement.worker, @agreement.project_id, (Date.today - 4.weeks))
  end
  
  private

  def permitted_params
    params.permit(agreement: [:project_id, :worker_id, :limit_min, :limit_max, :started_at, :ended_at])
  end

  def method_for_association_chain
    case params[:role]
    when 'worker' then
      :working_agreements
    when 'manager' then
      :managing_agreements
    else
      super
    end
  end

  def set_manager
    resource.manager = current_user
  end

  def notify_worker
    NotificationMailer.new_agreement(resource.id).deliver
  end

  def update_state
    if resource.can_change_by_manager?
      resource.change_by_manager
    elsif resource.can_change_by_worker?
      resource.change_by_worker
    end
  end

  def set_default_attributes
    resource.assign_attributes({
      limit_min: 40,
      limit_max: 40,
      started_at: Date.today.next_week.at_beginning_of_week,
      ended_at: Date.today.next_week.at_end_of_week
    })
  end

end
