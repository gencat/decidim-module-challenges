# frozen_string_literal: true

module Decidim
  module Solutions
    # Controller that allows browsing solutions.
    #
    class SolutionsController < Decidim::Solutions::ApplicationController
      include Decidim::ApplicationHelper
      include FilterResource
      include Paginable
      include OrderableSolutions
      include FormFactory
      include WithSdgs

      helper Decidim::CheckBoxesTreeHelper
      helper Decidim::Sdgs::SdgsHelper
      helper Decidim::ShowFiltersHelper
      helper SolutionsHelper
      helper Decidim::Challenges::ApplicationHelper

      helper_method :solutions, :form_presenter, :has_sdgs?, :has_problem?

      def index
        @solutions = search.result
        @solutions = reorder(@solutions)
        @solutions = paginate(@solutions)
      end

      def show
        @solution = solution
        if @solution.problem.present?
          @sectorial_scope = sectorial_scope
          @technological_scope = technological_scope
        end
        @sdg_index = sdg_index if @solution.problem.present? || @solution.challenge.present?
        @challenge_scope = challenge_scope
      end

      def new
        enforce_permission_to :create, :solution
        @form = form(Decidim::Solutions::SolutionsForm).instance
      end

      def create
        enforce_permission_to :create, :solution
        @form = form(Decidim::Solutions::SolutionsForm).from_params(params.merge({ author_id: current_user.id }))

        Decidim::Solutions::CreateSolution.call(@form) do
          on(:ok) do
            flash[:notice] = I18n.t("solutions.create.success", scope: "decidim.solutions")
            redirect_to solutions_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("solutions.create.error", scope: "decidim.solutions")
            render action: "new"
          end
        end
      end

      private

      def default_filter_params
        has_sdgs? ? default_filters.merge({ with_any_sdgs_codes: [] }) : default_filters
      end

      def default_filters
        {
          search_text_cont: "",
          with_any_territorial_scope: nil,
          with_any_sdgs_codes: [],
          related_to: "",
        }
      end

      def solutions
        @solutions ||= reorder(paginate(search.result))
      end

      def solution
        @solution ||= Solution.find(params[:id])
      end

      def sdg_index
        challenge = @solution.problem ? @solution.problem.challenge : @solution.challenge
        @sdg_index ||= challenge.sdg_code ? (1 + Decidim::Sdgs::Sdg.index_from_code(challenge.sdg_code.to_sym)).to_s.rjust(2, "0") : nil
      end

      def challenge_scope
        @challenge_scope ||= if @solution.problem.present?
                               current_organization.scopes.find_by(id: @solution.problem.challenge.decidim_scope_id)
                             else
                               current_organization.scopes.find_by(id: @solution.challenge&.decidim_scope_id)
                             end
      end

      def sectorial_scope
        @sectorial_scope ||= current_organization.scopes.find_by(id: @solution.problem.decidim_sectorial_scope_id)
      end

      def technological_scope
        @technological_scope ||= current_organization.scopes.find_by(id: @solution.problem.decidim_technological_scope_id)
      end

      def search_collection
        ::Decidim::Solutions::Solution.where(component: current_component).published
      end

      def form_presenter
        @form_presenter ||= present(@form, presenter_class: Decidim::Solutions::SolutionPresenter)
      end

      def has_problem?
        current_participatory_space.components.where(manifest_name: "problems").present? && @solution.problem.present?
      end
    end
  end
end
