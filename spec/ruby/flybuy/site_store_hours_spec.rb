# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Flybuy::SiteStoreHours do
  describe '.create' do
    let(:client) { double('Flybuy::Client') }
    let(:regular_hours) { { '1': [{ open: '09:00', close: '17:00' }] } }
    let(:store_hours_params) { { site_id: 42, regular_hours: regular_hours } }
    let(:response) { { data: { id: 7, site_id: 42, regular_hours: regular_hours } } }

    before do
      allow(Flybuy).to receive(:client).and_return(client)
      allow(client).to receive(:post).and_return(response)
    end

    it 'returns store hours built from the response data' do
      store_hours = described_class.create(store_hours_params)

      expect(store_hours).to be_a(Flybuy::SiteStoreHours)
      expect(store_hours.id).to eq(7)
      expect(store_hours.site_id).to eq(42)
      expect(store_hours.regular_hours).to eq(regular_hours)
    end

    it 'posts the hash wrapped in a data key to the site store hours path' do
      described_class.create(store_hours_params)

      expect(client).to have_received(:post).with('sites/42/site_store_hours/', { data: store_hours_params })
    end
  end
end
