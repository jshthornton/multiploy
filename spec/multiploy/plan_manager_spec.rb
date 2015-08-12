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
    it 'calls lower-level' do
      allow(Object).to receive(:const_get)
      expect(Object).to receive(:const_get).once.with('hello')

      subject.summon_class('hello')
    end

    it 'returns class' do
      Klass = subject.summon_class('Multiploy::PlanManager')

      expect(Klass).to eq(Multiploy::PlanManager)
    end
  end
end