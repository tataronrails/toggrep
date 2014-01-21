class AgreementsController < ApplicationController

  before_action :load_agreement, only: :create

  load_and_authorize_resource

  before_action :find_agreement, except: [:new, :create, :index]

  def new
    @agreement = Agreement.new(limit_min: 40,
                               limit_max: 40,
                               started_at: Date.today.next_week.at_beginning_of_week,
                               ended_at: Date.today.next_week.at_end_of_week)
  end

  def create
    @agreement.manager = current_user
    if @agreement.save
      NotificationMailer.new_agreement_email(@agreement, @agreement.worker).deliver
      redirect_to @agreement
    end
  end

  def index
    @agreements = Agreement.user_agreements(current_user)
  end

  def edit

  end

  def update
    if @agreement.update(agreements_params)
      if @agreement.changed_by_worker?
        @agreement.change_by_manager
      else
        @agreement.change_by_worker
      end
      redirect_to @agreement
    else
      render 'edit'
    end
  end

  def show

  end

  def accept
    @agreement.accept
    redirect_to @agreement
  end

  def reject
    @agreement.reject
    redirect_to @agreement
  end

  def cancel
    @agreement.cancel
    redirect_to @agreement
  end

  private

  def load_agreement
    @agreement = Agreement.new(agreements_params)
  end

  def agreements_params
    params.require(:agreement).permit(:project_id, :worker_id, :limit_min, :limit_max, :started_at, :ended_at)
  end

  def find_agreement
    @agreement = Agreement.find(params[:id])
  end

end
