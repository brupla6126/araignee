require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/fabricators/ai_xor_fabricator'
require 'araignee/ai/core/filters/filter_running'

RSpec.describe Ai::Core::Xor do
  let(:world) { {} }
  let(:entity) { {} }

  let(:filter) { Ai::Core::Filters::FilterRunning.new }

  let(:children) { [] }
  let(:xor) { Fabricate(:ai_xor, children: children, filters: [filter]) }

  subject { xor }

  describe '#initialize' do
    context 'when children is not set' do
      let(:xor) { Fabricate(:ai_xor) }

      it 'children set to default value' do
        expect(subject.children).to eq([])
      end
    end
  end

  describe 'process' do
    subject { super().process(entity, world) }

    before { xor.start! }

    context 'when responses = [:succeeded]' do
      let(:children) { [Fabricate(:ai_node_succeeded)] }

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when responses = [:succeeded, :succeeded]' do
      let(:children) { [Fabricate(:ai_node_succeeded), Fabricate(:ai_node_succeeded)] }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when responses = [:failed]' do
      let(:children) { [Fabricate(:ai_node_failed)] }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when responses = [:failed, :succeeded, :busy]' do
      let(:children) { [Fabricate(:ai_node_failed), Fabricate(:ai_node_succeeded), Fabricate(:ai_node_busy)] }

      it 'is busy' do
        expect(subject.busy?).to eq(true)
      end
    end
  end

  describe 'initialize_responses' do
    subject { super().send(:initialize_responses) }

    it 'returns initialized responses' do
      expect(subject).to eq(busy: 0, failed: 0, succeeded: 0)
    end
  end

  describe 'prepare_nodes' do
    subject { super().send(:prepare_nodes, nodes) }

    let(:nodes) { [] }
    let(:sort_reversed) { false }

    context 'calling #filter' do
      before { allow(xor).to receive(:filter).with(children) { children } }

      let(:sort_reversed) { false }

      it 'calls #filter' do
        expect(xor).to receive(:filter).with(children)
        subject
      end
    end

    it '' do
      expect(subject).to eq(nodes)
    end
  end

  describe 'respond' do
    subject { super().send(:respond, responses, response) }

    before { subject }

    let(:responses) { { busy: 0 } }
    let(:response) { :busy }

    it 'busy responses count equals 1' do
      expect(responses[response] == 1)
    end
  end
end
