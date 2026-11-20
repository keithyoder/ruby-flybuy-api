# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Flybuy::Site do
  describe '.create' do
    let(:client) { double('Flybuy::Client') }
    let(:site_params) { { name: 'Test Site', partner_identifier: '101' } }
    let(:response) { { data: { id: 123, name: 'Test Site', partner_identifier: '101' } } }

    before do
      allow(Flybuy).to receive(:client).and_return(client)
      allow(client).to receive(:post).and_return(response)
    end

    it 'returns a site built from the response data' do
      site = described_class.create(site_params)

      expect(site).to be_a(Flybuy::Site)
      expect(site.id).to eq(123)
      expect(site.name).to eq('Test Site')
      expect(site.partner_identifier).to eq('101')
    end

    it 'posts the hash wrapped in a data key' do
      described_class.create(site_params)

      expect(client).to have_received(:post).with('sites/', { data: site_params })
    end
  end
end
