require_relative '../../../../lib/multiploy/actions/fetch/remote'


describe Multiploy::Fetch::Remote do
  subject { Multiploy::Fetch::Remote.new }

  describe '#validate_response' do
    context 'with invalid' do
      it 'returns string' do
        response = instance_double('HTTParty::Response', code: 500)
        subject.instance_variable_set(:@response, response)

        expect(subject.validate_response).to be_a(String)
      end
    end

    context 'with valid' do
      it 'return true' do
        response = instance_double('HTTParty::Response', code: 200)
        subject.instance_variable_set(:@response, response)

        expect(subject.validate_response).to eq(true)
      end
    end
  end

  describe '#valid_response?' do
    context 'is valid' do
      it 'return true' do
        allow(subject).to receive(:validate_response).and_return(true)
        expect(subject).to receive(:validate_response)

        expect(subject.valid_response?).to eq(true)
      end
    end

    context 'is invalid' do
      it 'return false' do
        allow(subject).to receive(:validate_response).and_return('This is an error')
        expect(subject).to receive(:validate_response)

        expect(subject.valid_response?).to eq(false)
      end
    end
  end

  describe '#fetch' do
    it 'pass down @url and @http_options' do
      allow(HTTParty).to receive(:get).and_return({})
      expect(HTTParty).to receive(:get).with('test', {})

      subject.url = 'test'
      subject.http_options = {}

      subject.fetch
    end

    it 'sets response' do
      response = instance_double('HTTParty::Response', code: 200)
      allow(HTTParty).to receive(:get).and_return(response)

      subject.fetch

      expect(subject.response).to eq(response)
    end
  end

  describe '#execute' do
    context 'success' do
      it 'returns response body' do
        response = instance_double('HTTParty::Response', code: 200, body: 'hello')

        allow(subject).to receive(:fetch)
        allow(subject).to receive(:valid_response?).and_return(true)
        allow(subject).to receive(:validate_response)

        subject.response = response

        expect(subject.execute).to eq(response.body)
      end
    end

    context 'fail' do
      it 'throws fail' do
        allow(subject).to receive(:fetch)
        allow(subject).to receive(:valid_response?).and_return(false)
        allow(subject).to receive(:validate_response).and_return('Error Message')

        expect { subject.execute }.to raise_error('Error Message')
      end
    end
  end
end
