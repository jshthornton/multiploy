require_relative '../../../../lib/multiploy/actions/deploy/default'


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
  end
end
