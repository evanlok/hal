require 'rails_helper'

RSpec.describe ClassNameValidator do
  class ClassNameValidatable
    include ActiveModel::Validations
    validates :name, class_name: true
    attr_accessor :name
  end

  let(:validatable) { ClassNameValidatable.new }

  describe 'with valid name' do
    it 'passes validation' do
      validatable.name = 'TestClass'
      expect(validatable).to be_valid
    end
  end

  describe 'with invalid name' do
    it 'fails validation' do
      validatable.name = 'inValid'
      expect(validatable).to_not be_valid
      expect(validatable.errors[:name].count).to eq(1)
    end
  end

  describe 'with empty string' do
    it 'passes validation' do
      validatable.name = ''
      expect(validatable).to be_valid
    end
  end
end
