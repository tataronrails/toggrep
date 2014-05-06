module AgreementsHelper

  def scope_role
    params[:role] == 'manager' ? :manager : :worker
  end

  def state_class_index(state)
    case state
      when 'accepted'
        'positive'
      when 'proposed'
        'warning'
      when 'changed_by_worker'
        'warning'
      else
        'negative'
    end
  end

  def state_class_show(state)
    case state
      when 'accepted'
        'green'
      when 'proposed'
        'teal'
      when 'changed_by_worker'
        'teal'
      else
        'red'
    end
  end

  def highlight_index(state)
    case state
      when 'accepted'
        'green-highlight'
      when 'proposed'
        'brown-highlight'
      when 'changed_by_worker'
        'brown-highlight'
      else
        'red-highlight'
    end
  end

end