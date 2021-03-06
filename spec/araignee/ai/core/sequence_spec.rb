require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/fabricators/ai_sequence_fabricator'

RSpec.describe Ai::Core::Sequence do
  let(:world) { {} }
  let(:entity) { {} }

  let(:filter) { Ai::Core::Filters::FilterRunning.new }
  let(:children) { [] }
  let(:sequence) { Fabricate(:ai_sequence, children: children, filters: [filter]) }

  let(:node_success) { Fabricate(:ai_node_succeeded) }
  let(:node_failed) { Fabricate(:ai_node_failed) }
  let(:node_busy) { Fabricate(:ai_node_busy) }

  subject { sequence }

  describe '#initialize' do
    context 'when children is not set' do
      let(:sequence) { Fabricate(:ai_sequence) }

      it 'children set to default value' do
        expect(subject.children).to eq([])
      end
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }
    before { sequence.start! }

    let(:children) { [node_success] }

    context 'calling #prepare_nodes' do
      before { allow(sequence).to receive(:prepare_nodes).with(children, sort_reversed) { children } }

      let(:sort_reversed) { false }

      it 'calls #prepare_nodes' do
        expect(sequence).to receive(:prepare_nodes).with(children, sort_reversed)
        subject
      end
    end

    context 'calling each child#process' do
      before do
        children.each do |child|
          allow(child).to receive(:process).with(entity, world) { child }
        end
      end

      it 'calls each child#process' do
        children.each do |child|
          expect(child).to receive(:process).with(entity, world)
        end

        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when children = :succeeded, :succeeded' do
      let(:children) { [Fabricate(:ai_node_succeeded), Fabricate(:ai_node_succeeded)] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when children = :succeeded, :busy, :succeeded' do
      let(:children) { [Fabricate(:ai_node_succeeded), node_busy, Fabricate(:ai_node_succeeded)] }

      it 'should be busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'when children = :failed, :succeeded' do
      let(:children) { [node_failed, node_success] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
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
    subject { super().send(:prepare_nodes, nodes, sort_reversed) }

    let(:nodes) { [] }
    let(:sort_reversed) { false }

    context 'calling #filter and #sort' do
      before { allow(sequence).to receive(:filter).with(children) { children } }
      before { allow(sequence).to receive(:sort).with(children, sort_reversed) { children } }

      let(:sort_reversed) { false }

      it 'calls #filter and #sort' do
        expect(sequence).to receive(:filter).with(children)
        expect(sequence).to receive(:sort).with(children, sort_reversed)
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
