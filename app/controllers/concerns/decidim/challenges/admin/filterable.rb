# frozen_string_literal: true

require 'active_support/concern'

module Decidim
  module Challenges
    module Admin
      module Filterable
        extend ActiveSupport::Concern

        included do
          include Decidim::Admin::Filterable

          private

          def base_query
            collection
          end

          def extra_filters
            []
          end
        end
      end
    end
  end
end
