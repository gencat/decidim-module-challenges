# frozen_string_literal: true

module Decidim
  module Solutions
    module Admin
      # Controller that allows managing admin problems.
      #
      class SolutionsController < Decidim::Solutions::Admin::ApplicationController
        include Decidim::ApplicationHelper

        helper_method :solution, :solution, :form_presenter

        def index
          enforce_permission_to :read, :solutions
          @solutions = solutions
        end

        def new
          enforce_permission_to :create, :solution
          @form = form(Decidim::Solutions::Admin::SolutionsForm).instance
        end

        def create
          enforce_permission_to :create, :solution
          @form = form(Decidim::Solutions::Admin::SolutionsForm).from_params(params, author_id: current_user.id)

          Decidim::Solutions::Admin::CreateSolution.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("solutions.create.success", scope: "decidim.solutions.admin")
              redirect_to solutions_path(assembly_slug: -1, component_id: -1)
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("solutions.create.error", scope: "decidim.solutions.admin")
              render action: "new"
            end
          end
        end

        def show
          enforce_permission_to :show, :solution
          @solution = Decidim::Solutions::Solution.find(params[:id])
        end

        def edit
          enforce_permission_to :edit, :solution, solution: solution
          @form = form(Decidim::Solutions::Admin::SolutionsForm).from_model(solution)
        end

        def update
          enforce_permission_to :edit, :solution, solution: solution
          @form = form(Decidim::Solutions::Admin::SolutionsForm).from_params(params)

          Decidim::Solutions::Admin::UpdateSolution.call(@form, solution) do
            on(:ok) do |_solution|
              flash[:notice] = t("solutions.update.success", scope: "decidim.solutions.admin")
              redirect_to solutions_path(assembly_slug: -1, component_id: -1)
            end

            on(:invalid) do
              flash.now[:alert] = t("solutions.update.error", scope: "decidim.solutions.admin")
              render :edit
            end
          end
        end

        def destroy
          enforce_permission_to :destroy, :solution, solution: solution

          Decidim::Solutions::Admin::DestroySolution.call(solution, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("solutions.destroy.success", scope: "decidim.solutions.admin")
              redirect_to solutions_path(assembly_slug: -1, component_id: -1)
            end

            on(:invalid) do
              flash.now[:alert] = t("solutions.destroy.error", scope: "decidim.solutions.admin")
              redirect_to solutions_path(assembly_slug: -1, component_id: -1)
            end
          end
        end

        private

        def collection
          @collection ||= Solution.where(component: current_component)
        end

        def solutions
          @solutions ||= collection.page(params[:page]).per(10)
        end

        def solution
          @solution ||= collection.find(params[:id])
        end

        def form_presenter
          @form_presenter ||= present(@form, presenter_class: Decidim::Solutions::SolutionPresenter)
        end
      end
    end
  end
end
