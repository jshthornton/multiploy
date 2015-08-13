require_relative '../../../lib/multiploy/plans/default'

describe Multiploy::Plans::Default do
  subject { described_class.new }

  describe '#execute' do
    before(:each) do
      subject.fetcher = double('Multiploy::Fetch::Remote')
      subject.storer = double('Multiploy::Store::File')
      subject.transferer = double('Multiploy::Transfer::SSHKitFile')
      subject.deployer = double('Multiploy::Organizer')

      allow(subject.fetcher).to receive(:execute)
      allow(subject.storer).to receive(:execute)
      allow(subject.transferer).to receive(:execute)
      allow(subject.deployer).to receive(:execute)
      allow(subject.storer).to receive(:data=)
    end

    it 'executes all stages' do
      expect(subject.fetcher).to receive(:execute).once
      expect(subject.storer).to receive(:execute).once
      expect(subject.transferer).to receive(:execute).once
      expect(subject.deployer).to receive(:execute).once

      subject.execute
    end

    it 'set data for storer from fetcher' do
      expect(subject.storer).to receive(:data=).once

      subject.execute
    end
  end
end

describe Multiploy::Plans::DefaultFactory do
  subject { described_class.new }

  describe '#make' do
    before(:each) do
      Configuration.for('fetch') do
        url 'http://about:blank/'
        http_options do

        end
      end

      Configuration.for('store') do
        output_path '/tmp/app.tar.gz'
      end

      Configuration.for('transfer') do
        remote_path '/tmp/#{SecureRandom.uuid}.tar.gz'
      end

      Configuration.for('deploy') do
        naming_mechanism 'datetime'
      end
    end

    after(:each) do
      Object.send(:remove_const, 'Configuration')
      load 'configuration.rb'
    end

    it 'returns plan' do
      expect(subject.make).to be_instance_of(Multiploy::Plans::Default)
    end
  end
end