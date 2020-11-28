# frozen_string_literal: true

module Decidim
  module Solutions
    # A service to encapsualte all the logic when searching and filtering
    # Solutions in a participatory process.
    class SolutionSearch < ResourceSearch
      # text_search_fields :title

      # Public: Initializes the service.
      # component   - A Decidim::Component to get the solutions from.
      # page        - The page number to paginate the results.
      # per_page    - The number of solutions to return per page.
      def initialize(options = {})
        super(Solution.published.all, options)
      end

      # Handle the search_text filter
      def search_search_text
        query.where("title ->> '#{I18n.locale}' ILIKE ?", "%#{search_text}%")
      end

      def search_sdgs_codes
        query.joins(problem: :challenge).where("decidim_challenges_challenges.sdg_code" => sdgs_codes)
      end
    end
  end
end
