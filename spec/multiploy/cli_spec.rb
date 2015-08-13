require_relative '../../lib/multiploy/cli'

describe Multiploy::CLI do
  subject { described_class.new }

  describe '#initialize' do
    it 'Should call assign defaults' do
      allow_any_instance_of(described_class).to receive(:assign_defaults).and_return(nil)
      expect_any_instance_of(described_class).to receive(:assign_defaults)

      described_class.new
    end
  end

  describe '#run' do
    it 'call execute on command' do
      klass = Class.new do
        def execute
        end
      end

      command = klass.new
      argv = double('ARGV')

      allow(argv).to receive(:shift)
      allow(argv).to receive(:[]=)

      expect(command).to receive(:execute).once

      subject.command = command
      subject.args = argv

      subject.run
    end
  end
end