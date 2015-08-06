require_relative '../../../../lib/multiploy/actions/fetch/remote'


describe Multiploy::Fetch::Remote do
  subject { Multiploy::Fetch::Remote.new }

  describe '#validate_response' do
    context 'with invalid' do
      it 'returns string' do
        response = instance_double('HTTParty::Response', :code => 500)
        subject.instance_variable_set(:@response, response)

        expect(subject.validate_response).to be_a(String)
      end
    end

    context 'with valid' do
      it 'return true' do
        response = instance_double('HTTParty::Response', :code => 200)
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
end
