class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include HumanReadable
end
