require_relative '../../lib/multiploy/application'

describe Multiploy::Application do
  subject { described_class.new }

  # describe '#load_default_config' do
  #   it 'uses local config path' do
  #     allow(Configuration).to receive(:path=)
  #     allow(Configuration).to receive(:load)

  #     expect(Configuration).to receive(:path=).with(end_with('lib/multiploy/config'))

  #     subject.load_default_config
  #   end
  # end

  # describe '#load_user_config' do
  #   it 'uses user config path' do
  #     allow(Configuration).to receive(:path=)
  #     allow(Configuration).to receive(:load)

  #     expect(Configuration).to receive(:path=).with(end_with('config'))

  #     subject.load_user_config
  #   end
  # end
end