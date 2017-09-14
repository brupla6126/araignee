require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/busy'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/limiter'

include AI::Actions

RSpec.describe AI::Behaviors::Limiter do
  let(:world) { double('[world]') }
  let(:entity) { {} }
  before { allow(world).to receive(:delta) { 1 } }

  let(:action_success) { ActionSucceeded.new({}) }
  let(:action_failure) { ActionFailed.new({}) }
  let(:action_busy) { ActionBusy.new({}) }
  let(:node) { action_success }
  let(:times) { 1 }
  let(:limiter) { AI::Behaviors::Limiter.new(node: node, times: times) }

  describe '#initialize' do
    subject { limiter }
    context 'when times is not set' do
      let(:limiter) { AI::Behaviors::Limiter.new(node: node) }

      it 'times should default to 1' do
        expect(subject.times).to eq(1)
      end
    end

    context 'when times parameter is set to <= 0' do
      let(:times) { 0 }

      it 'should raise ArgumentError, times must be > 0' do
        expect { subject }.to raise_error(ArgumentError, 'times must be > 0')
      end
    end
  end

  describe '#process' do
    subject { limiter }
    before { limiter.start! }

    let(:times) { 3 }

    context 'when doing 5 loops of ActionSucceeded and :times equals to 3' do
      let(:node) { action_busy }

      it 'should have failed' do
        1.upto(5) do
          limiter.process(entity, world)
          break if limiter.succeeded? || limiter.failed?
        end

        expect(subject.failed?).to eq(true)
      end
    end

    context 'when doing 2 loops of ActionSucceeded and :times equals to 3' do
      it 'should have succeeded' do
        1.upto(2) do
          limiter.process(entity, world)
          break if limiter.succeeded? || limiter.failed?
        end

        expect(subject.succeeded?).to eq(true)
      end
    end

    it 'returns self' do
      expect(subject).to eq(limiter)
    end
  end
end
