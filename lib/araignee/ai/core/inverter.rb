require 'araignee/ai/core/decorator'

# Module for gathering AI classes
module Ai
  module Core
    # Inverter will invert or negate the result of their child node.
    # Response :succeeded becomes :failed, and :failed becomes :succeeded.
    class Inverter < Decorator
      def execute(entity, world)
        responded = child.process(entity, world).response

        update_response(handle_response(responded))
      end

      protected

      def handle_response(responded)
        case responded
        when :succeeded
          :failed
        when :failed
          :succeeded
        else
          responded
        end
      end
    end
  end
end
