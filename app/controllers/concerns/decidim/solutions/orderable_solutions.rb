# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Solutions
    # Common logic to sorting resources
    module OrderableSolutions
      extend ActiveSupport::Concern

      included do
        include Decidim::Orderable

        private

        def available_orders
          @available_orders ||= %w(random recent)
        end

        def default_order
          "random"
        end

        def reorder(solutions)
          case order
          when "recent"
            solutions.order("created_at DESC")
          when "random"
            solutions.order_randomly(random_seed)
          else
            solutions
          end
        end
      end
    end
  end
end
