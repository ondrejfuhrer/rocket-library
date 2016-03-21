require 'rails_helper'

RSpec.describe BooksHelper do
  describe '#get_bootstrap_class_for_state' do
    it 'returns empty class for unknown state' do
      expect(helper.get_bootstrap_class_for_state('unknown')).to eq('')
    end

    it 'returns value for active state' do
      expect(helper.get_bootstrap_class_for_state('active')).to eq('label label-success')
    end

    it 'returns value for rented state' do
      expect(helper.get_bootstrap_class_for_state('rented')).to eq('label label-danger')
    end
  end
end
