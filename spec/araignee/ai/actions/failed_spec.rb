require 'araignee/ai/actions/failed'

include AI::Actions

RSpec.describe AI::Actions::ActionFailed do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:action) { ActionFailed.new }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  describe '#process' do
    before { action.fire_state_event(:start) }
    subject { action.process(entity, world) }

    it 'should have failed' do
      expect(subject.failed?).to eq(true)
    end
  end
end

RSpec.describe AI::Actions::ActionTemporaryFailed do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  describe '#process' do
    let(:times) { 0 }
    let(:action) { ActionTemporaryFailed.new(times: times) }

    before { action.fire_state_event(:start) }
    subject { action.process(entity, world) }

    it 'should have succeeded' do
      expect(subject.succeeded?).to eq(true)
    end

    context 'fail twice' do
      let(:times) { 2 }

      it 'should fail twice and then succeed' do
        1.upto(times + 1) do |i|
          action.process(entity, world)

          if i <= times
            expect(action.failed?).to eq(true)
          else
            expect(action.succeeded?).to eq(true)
          end
        end
      end
    end
  end
end