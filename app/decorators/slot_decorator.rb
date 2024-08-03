class SlotDecorator < Draper::Decorator
  delegate_all
  def service_type_label
    case service_type
    when 'full_service'
      'Full Service'
    when 'engine_service'
      'Engine Service'
    when 'wash_service'
      'Wash Service'
    else
      'Unknown Service Type'
    end
  end
end
