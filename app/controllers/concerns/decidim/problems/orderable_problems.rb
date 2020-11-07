# frozen_string_literal: true

require 'active_support/concern'

module Decidim
  module Problems
    # Common logic to sorting resources
    module OrderableProblems
      extend ActiveSupport::Concern

      included do
        include Decidim::Orderable

        private

        def available_orders
          @available_orders ||= %w[random recent]
        end

        def default_order
          'random'
        end

        def reorder(problems)
          case order
          when 'recent'
            problems.order('created_at DESC')
          when 'random'
            problems.order_randomly(random_seed)
          else
            problems
          end
        end
      end
    end
  end
end
