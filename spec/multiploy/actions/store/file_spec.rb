require_relative '../../../../lib/multiploy/actions/store/file'


describe Multiploy::Store::File do
  subject { described_class.new }

  describe '#execute' do
    it 'opens with write permissions' do
      file = double('File')
      allow(File).to receive(:open).and_yield(file)
      allow(file).to receive(:write)

      expect(File).to receive(:open).with(anything, 'wb')

      subject.execute
    end

    it 'opens the output path' do
      file = double('File')
      allow(File).to receive(:open).and_yield(file)
      allow(file).to receive(:write)

      expect(File).to receive(:open).with('hello', anything)

      subject.output_path = 'hello'

      subject.execute
    end

    it 'writes data' do
      file = double('File')
      allow(File).to receive(:open).and_yield(file)
      allow(file).to receive(:write)

      expect(file).to receive(:write).with('hello')

      subject.data = 'hello'

      subject.execute
    end
  end
end
