class ClassNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present? && value !~ /\A[A-Z]\w*\z/
      message = 'must contain a uppercase first character and letters, numbers, and underscores for subsequent characters'
      record.errors[attribute] << (options[:message] || message)
    end
  end
end
