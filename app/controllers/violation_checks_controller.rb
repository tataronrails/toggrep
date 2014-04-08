class ViolationChecksController < InheritedResources::Base

  belongs_to :agreement
  actions :index

  def index
    if current_user != parent.manager
      redirect_to root_path
    end
  end

  protected
    def collection
      @violation_checks ||= end_of_association_chain.success
    end

end
