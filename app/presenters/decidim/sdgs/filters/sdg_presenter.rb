# frozen_string_literal: true

module Decidim
  module Sdgs
    module Filters
      #
      # Decorator for Sdg
      #
      class SdgPresenter < SimpleDelegator
        def id_and_title
          "#{id}. #{sdg_name}"
        end

        def id
          ::Decidim::Sdgs::Sdg::SDGS.index(sdg_name)
        end

        private

        def sdg_name
          __getobj__
        end
      end
    end
  end
end
