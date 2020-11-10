# frozen_string_literal: true

module Decidim
    module Problems
        # This cell renders the budget project card for an instance of a project
        # the default size is the Medium Card (:m)
        class ProblemCell < Decidim::ViewModel
            include Cell::ViewModel::Partial

            def show
                cell card_size, model, options
            end

            private

            def card_size
                "decidim/problems/problem_m"
            end
        end
    end
end
