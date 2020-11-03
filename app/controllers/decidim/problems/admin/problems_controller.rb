# frozen_string_literal: true

module Decidim
  module Problems
    module Admin
      # Controller that allows managing admin problems.
      #
      class ProblemsController < Decidim::Problems::Admin::ApplicationController
        include Decidim::ApplicationHelper

        helper_method :problems, :problem, :form_presenter

        def index
          enforce_permission_to :read, :problems
          @problems = problems
        end

        def new
          enforce_permission_to :create, :problem
          @form = form(Decidim::Problems::Admin::ProblemsForm).instance
        end

        def create
          enforce_permission_to :create, :problem
          @form = form(Decidim::Problems::Admin::ProblemsForm).from_params(params)

          Decidim::Problems::Admin::ProblemChallenge.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t('problems.create.success', scope: 'decidim.problems.admin')
              redirect_to problems_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t('problems.create.error', scope: 'decidim.problems.admin')
              render action: 'new'
            end
          end
        end

        def edit
          enforce_permission_to :edit, :problem, problem: problem
          @form = form(Decidim::Problems::Admin::ProblemsForm).from_model(problem)
        end

        def update
          enforce_permission_to :edit, :problem, problem: problem
          @form = form(Decidim::Problems::Admin::ProblemsForm).from_params(params)

          Decidim::Problems::Admin::UpdateProblem.call(@form, problem) do
            on(:ok) do |_problem|
              flash[:notice] = t('problems.update.success', scope: 'decidim.problems.admin')
              redirect_to problems_path
            end

            on(:invalid) do
              flash.now[:alert] = t('problems.update.error', scope: 'decidim.problems.admin')
              render :edit
            end
          end
        end

        def destroy
          enforce_permission_to :destroy, :problem, problem: problem

          Decidim::Problems::Admin::DestroyProblem.call(problem, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t('problems.destroy.success', scope: 'decidim.problems.admin')
              redirect_to problems_path
            end

            on(:invalid) do
              flash.now[:alert] = t('problems.destroy.error', scope: 'decidim.problems.admin')
              redirect_to problems_path
            end
          end
        end

        private

        def collection
          @collection ||= Problem.where(component: current_component)
        end

        def problems
          @problems ||= collection.page(params[:page]).per(10)
        end

        def problem
          @problem ||= collection.find(params[:id])
        end

        def form_presenter
          @form_presenter ||= present(@form, presenter_class: Decidim::Problems::ProblemPresenter)
        end
      end
    end
  end
end
