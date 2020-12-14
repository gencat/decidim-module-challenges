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

      # Handles the territorial challenge.scope_id filter. When we want to show only those that do not
      # have a scope_id set, we cannot pass an empty String or nil because Searchlight
      # will automatically filter out these params, so the method will not be used.
      # Instead, we need to pass a fake ID and then convert it inside. In this case,
      # in order to select those elements that do not have a scope_id set we use
      # `"global"` as parameter, and in the method we do the needed changes to search
      # properly.
      def search_territorial_scope_id
        return query if territorial_scope_id.include?("all")

        clean_scope_ids = territorial_scope_id

        conditions = []
        conditions << "decidim_challenges_challenges.decidim_scope_id IS NULL" if clean_scope_ids.delete("global")
        conditions.concat(["? = ANY(decidim_scopes.part_of)"] * clean_scope_ids.count) if clean_scope_ids.any?

        query.includes(problem: { challenge: :scope }).references(:decidim_scopes).where(conditions.join(" OR "), *clean_scope_ids.map(&:to_i))
      end

      def search_sdgs_codes
        query.joins(problem: :challenge).where("decidim_challenges_challenges.sdg_code" => sdgs_codes)
      end
    end
  end
end
