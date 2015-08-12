require_relative '../../lib/multiploy/plan_manager'

describe Multiploy::PlanManager do
  subject { described_class.new }

  describe '#load' do
    it 'calls kernel load' do
      allow(Kernel).to receive(:load)
      expect(Kernel).to receive(:load).once.with('hello')

      subject.load('hello')
    end
  end

  describe '#summon_class' do

  end
end