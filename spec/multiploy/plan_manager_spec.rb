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

  describe '#resolve_factory' do
    context 'with class method' do
      let(:klass) do
        Class.new do
          def self.make
            'class'
          end
        end
      end

      it 'returns result from class method' do
        expect(subject.resolve_factory(klass)).to eq('class')
      end
    end

    context 'with factory instance' do
      let(:klass) do
        Class.new do
          def make
            'factory'
          end
        end
      end

      it 'returns result from factory' do
        expect(subject.resolve_factory(klass)).to eq('factory')
      end
    end

    context 'with raw' do
      let(:klass) do
        Class.new do
        end
      end

      it 'returns raw class' do
        expect(subject.resolve_factory(klass)).to be_an_instance_of(klass)
      end
    end
  end
end