require_relative '../../lib/multiploy/configuration_helper'

describe Multiploy::ConfigurationHelper do
  subject { described_class.new }

  describe '#load_default_config' do
    it 'uses local config path' do
      allow(Configuration).to receive(:path=)
      allow(Configuration).to receive(:load)

      expect(Configuration).to receive(:path=).with(end_with('lib/multiploy/config'))

      subject.load_default_config
    end
  end

  describe '#load_user_config' do
    it 'uses user config path' do
      allow(Configuration).to receive(:path=)
      allow(Configuration).to receive(:load)

      expect(Configuration).to receive(:path=).with(end_with('config'))

      subject.load_user_config
    end
  end

  describe '#merge_config' do
    after(:each) do
      Object.send(:remove_const, 'Configuration')
      load 'configuration.rb'
    end

    it 'create a merge of data' do
      Configuration.for('default/a') do
        hello 'world!'
        default true
      end

      Configuration.for('user/a') do
        hello 'bob!'
        user true
      end

      subject.items = ['a']
      subject.merge_config

      a = Configuration.for 'a'

      expect(a.hello).to eq('bob!')
      expect(a.default).to eq(true)
      expect(a.user).to eq(true)
    end
  end
end