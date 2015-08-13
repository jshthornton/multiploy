require_relative '../../../../lib/multiploy/actions/deploy/default'

describe Multiploy::Deploy::ActionFactory do
  subject { described_class.new }

  describe '#makeSetup' do
  end

  describe '#makeInstall' do

  end

  describe '#makeDeploy' do

  end
end

describe Multiploy::Deploy::DateTimeNaming do
  subject { described_class.new }

  describe '#name' do
    it 'use current time' do
      expect(DateTime).to receive(:now).and_call_original

      name = subject.name
    end

    it 'supplys a string' do
      allow(DateTime).to receive(:now).and_call_original

      name = subject.name
      expect(name).to be_a(String)
    end

    it 'is memoized' do
      allow(DateTime).to receive(:now).and_call_original
      expect(DateTime).to receive(:now).once

      subject.name
    end
  end
end

describe Multiploy::Deploy::SetupDirectory do
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
    it 'calls execute for backend' do
      backend = Object.new
      backend.define_singleton_method(:execute!) do |*args|
      end

      subject.path = 'hello'

      allow(backend).to receive(:instance_exec).and_call_original
      allow(backend).to receive(:execute!)

      expect(backend).to receive(:execute!).with(:mkdir, '-p', 'hello')

      backend.instance_exec({}, &subject.backend_action)
    end
  end
end

describe Multiploy::Deploy::MoveToDestination do
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
    it 'calls execute for backend' do
      backend = Object.new
      backend.define_singleton_method(:execute!) do |*args|
      end

      subject.src_path = 'hello'
      subject.dest_path = 'world'

      allow(backend).to receive(:instance_exec).and_call_original
      allow(backend).to receive(:execute!)

      expect(backend).to receive(:execute!).with(:tar, '-zxvf', 'hello', '-C', 'world', '--strip')

      backend.instance_exec({}, &subject.backend_action)
    end
  end
end
