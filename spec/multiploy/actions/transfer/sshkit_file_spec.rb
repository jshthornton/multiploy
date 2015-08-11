require_relative '../../../../lib/multiploy/actions/transfer/sshkit_file'


describe Multiploy::Transfer::SSHKitFile do
  subject { described_class.new }

  describe '#execute' do
    it 'sends upload block into each' do
      backend = double('SSHKit::Backend::Netssh')
      coordinator = double('SSHKit::Coordinator')

      allow(coordinator).to receive(:each) do

      end
    end
  end

  describe '@backend_action' do
    it 'calls upload for backend' do

    end
  end
end

describe Multiploy::Transfer::SSHKitFileFactory do
  subject { described_class.new }
end