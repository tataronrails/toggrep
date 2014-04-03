module AgreementsHelper

  def scope_role
    params[:role] == 'manager' ? :manager : :worker
  end

end