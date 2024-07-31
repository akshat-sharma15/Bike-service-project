module ApplicationHelper
  def status_badge_class(status)
    case status
    when 'pending'
      'warning'
    when 'confirmed'
      'primary'
    when 'active'
      'info'
    when 'completed'
      'success'
    else
      'secondary'
    end
  end
end
