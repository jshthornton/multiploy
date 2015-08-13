require_relative '../../../../lib/multiploy/actions/deploy/default'

describe Multiploy::Deploy::ActionFactory do
  subject { described_class.new }

  describe '#makeSetup' do
    it 'return organizer' do
      expect(subject.makeSetup(OpenStruct.new)).to be_instance_of(Multiploy::Organizer)
    end
  end

  describe '#makeInstall' do
    it 'return organizer' do
      options = OpenStruct.new(
      )
      expect(subject.makeInstall(options)).to be_instance_of(Multiploy::Organizer)
    end
  end

  describe '#makeDeploy' do
    it 'return organizer' do
      options = OpenStruct.new(
        naming_mechanism: 'datetime'
      )
      expect(subject.makeDeploy(options)).to be_instance_of(Multiploy::Organizer)
    end
  end
end

describe Multiploy::Deploy::NamingFactory do
  subject { described_class.new }

  describe '#make' do
    it 'creates DateTime' do
      expect(subject.make('datetime')).to be_instance_of(Multiploy::Deploy::DateTimeNaming)
    end

    it 'creates UUID' do
      expect(subject.make('uuid')).to be_instance_of(Multiploy::Deploy::UUIDNaming)
    end

    it 'errors on unknown' do
      expect { subject.make(nil) }.to raise_error('Unknown naming mechanism')
    end
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
      name = subject.name
      expect(name).to be_a(String)
    end

    it 'is memoized' do
      expect(DateTime).to receive(:now).once.and_call_original

      subject.name
    end
  end
end

describe Multiploy::Deploy::UUIDNaming do
  subject { described_class.new }

  describe '#name' do
    it 'use current time' do
      expect(SecureRandom).to receive(:uuid).and_call_original

      name = subject.name
    end

    it 'supplys a string' do
      name = subject.name
      expect(name).to be_a(String)
    end

    it 'is memoized' do
      expect(SecureRandom).to receive(:uuid).once.and_call_original

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

describe Multiploy::Deploy::DeleteSource do
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

      expect(backend).to receive(:execute!).with(:rm, 'hello')

      backend.instance_exec({}, &subject.backend_action)
    end
  end
end

describe Multiploy::Deploy::Unpublish do
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

      expect(backend).to receive(:execute!).with(:unlink, 'hello')

      backend.instance_exec({}, &subject.backend_action)
    end
  end
end

describe Multiploy::Deploy::Publish do
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

      subject.file_path = 'hello'
      subject.symlink_path = 'world'

      allow(backend).to receive(:instance_exec).and_call_original
      allow(backend).to receive(:execute!)

      expect(backend).to receive(:execute!).with(:ln, '-s', 'hello', 'world')

      backend.instance_exec({}, &subject.backend_action)
    end
  end
end
