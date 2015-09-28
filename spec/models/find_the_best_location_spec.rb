require 'rails_helper'

RSpec.describe FindTheBestLocation, type: :model do
  describe 'on create' do
    let(:find_the_best_location) { create(:find_the_best_location, definition: definition) }

    describe '#set_definition' do
      let(:definition) { nil }
      let!(:find_the_home_definition) { create(:definition, name: FindTheBestLocation::DEFINITION_NAME) }
      subject { find_the_best_location.definition }

      context 'when definition is not set' do
        it { is_expected.to eq(find_the_home_definition) }
      end

      context 'when definition is already set' do
        let(:definition) { create(:definition) }
        it { is_expected.to eq(definition) }
      end
    end
  end
end
