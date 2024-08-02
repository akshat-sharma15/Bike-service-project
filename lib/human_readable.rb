module HumanReadable
  def state(attribute)
    I18n.t("state_machine.#{self.class.name.underscore}.#{attribute}.#{send(attribute)}")
  end
end
