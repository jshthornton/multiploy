require_relative '../../../../lib/multiploy/actions/transfer/sshkit_file'


describe Multiploy::Transfer::SSHKitFile do
  subject { described_class.new }

  describe '#execute' do
    it 'calls each backend' do
      coordinator = double('SSHKit::Coordinator')

      expect(coordinator).to receive(:each)

      subject.coordinator = coordinator
      subject.execute
    end
  end

  describe '#backend_action' do
    it 'calls upload for backend' do
      backend = Object.new
      subject.local_path = 'hello'
      subject.remote_path = 'world!'

      allow(backend).to receive(:instance_exec).and_call_original
      allow(backend).to receive(:upload!)

      expect(backend).to receive(:upload!).with('hello', 'world!')

      backend.instance_exec({}, &subject.backend_action)
    end
  end
end

describe Multiploy::Transfer::SSHKitFileFactory do
  subject { described_class.new }
end