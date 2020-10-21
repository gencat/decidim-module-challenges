# frozen_string_literal: true

module Decidim
  module Challenges
    # A service to encapsualte all the logic when searching and filtering
    # challenges in a participatory process.
    class ChallengeSearch < ResourceSearch
      text_search_fields :title

      # Public: Initializes the service.
      # component   - A Decidim::Component to get the challenges from.
      # page        - The page number to paginate the results.
      # per_page    - The number of challenges to return per page.
      def initialize(options = {})
        base = options[:status]
        super(base, options)
      end

      # Handle the activity filter
      def search_activity
        query
      end

      # Handle the state filter
      def search_status
        apply_scopes(%w[proposed running completed], status)
      end
    end
  end
end
