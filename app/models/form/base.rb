class Form::Base
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::AttributeMethods
  include ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
end