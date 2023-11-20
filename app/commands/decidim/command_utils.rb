# frozen_string_literal: true

module Decidim
  module CommandUtils
    def parsed_attribute(attribute)
      Decidim::ContentProcessor.parse_with_processor(:hashtag, form.send(attribute), current_organization: form.current_organization).rewrite
    end

    def challenge_id
      challenge = form.decidim_challenges_challenge_id
      problem = Decidim::Problems::Problem.find_by(id: form.decidim_problems_problem_id)

      if challenge.present?
        Decidim::Challenges::Challenge.find(form.decidim_challenges_challenge_id).id
      else
        problem&.decidim_challenges_challenge_id.presence
      end
    end
  end
end
