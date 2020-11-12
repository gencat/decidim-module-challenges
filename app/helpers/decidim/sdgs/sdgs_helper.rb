# frozen_string_literal: true

module Decidim
  module Sdgs
    # Custom helpers, scoped to the Sdgs engine.
    #
    module SdgsHelper
      def t_sdg(name)
        t(name, scope: "decidim.sdgs.names")
      end
    end
  end
end
