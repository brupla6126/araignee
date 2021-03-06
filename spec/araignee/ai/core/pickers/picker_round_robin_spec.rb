require 'araignee/ai/core/pickers/picker_round_robin'

RSpec.describe Ai::Core::Pickers::PickerRoundRobin do
  let(:picker) { described_class.new }
  subject { picker }

  let(:nodes) { %i[a d b c] }

  describe '#initialize' do
    it 'assigns attributes' do
      expect(subject.current).to eq(0)
    end
  end

  describe '#pick_one' do
    it 'returns appropriate node' do
      expect(subject.pick_one(nodes)).to eq(nodes[0])
      expect(subject.pick_one(nodes)).to eq(nodes[1])
      expect(subject.pick_one(nodes)).to eq(nodes[2])
      expect(subject.pick_one(nodes)).to eq(nodes[3])
      expect(subject.pick_one(nodes)).to eq(nodes[0])
    end
  end

  describe 'reset' do
    subject { super().reset }

    before { picker.pick_one(nodes) }
    before { subject }

    it 'resets current to 0' do
      expect(picker.current).to eq(0)
    end
  end
end
