# frozen_string_literal: true

require "spec_helper"

describe Decidim::Solutions::Admin::SolutionsController do
  routes { Decidim::Solutions::AdminEngine.routes }

  let(:organization) { create(:organization, available_locales: [:en]) }
  let(:title) do
    {
      en: "Solution title",
      es: "Título solución",
      ca: "Títol solució",
    }
  end
  let(:description) do
    {
      en: "Solution description",
      es: "Descripción solución",
      ca: "Descripció solució",
    }
  end
  let(:challenge) { create(:challenge) }
  let(:problem) { create(:problem, challenge: challenge) }
  let(:tags) { "tag1, tag2, tag3" }
  let(:objectives) do
    { en: "objectives" }
  end
  let(:indicators) do
    { en: "indicators" }
  end
  let(:beneficiaries) do
    { en: "beneficiaries" }
  end
  let(:financing_type) do
    { en: "financing_type" }
  end
  let(:requirements) do
    { en: "requirements" }
  end
  let(:params) do
    {
      solution: {
        title: title,
        description: description,
        author_id: current_user.id,
        decidim_problems_problem_id: problem.id,
        tags: tags,
        objectives: objectives,
        indicators: indicators,
        beneficiaries: beneficiaries,
        financing_type: financing_type,
        requirements: requirements,
      },
      component_id: component,
      scope: scope,
      participatory_process_slug: component.participatory_space.slug,
    }
  end
  let(:current_user) { create(:user, :admin, :confirmed, organization: organization) }
  let(:participatory_process) { create(:participatory_process, organization: organization) }
  let(:component) { create(:component, participatory_space: participatory_process, manifest_name: "solutions", organization: organization) }
  let(:scope) { create(:scope, organization: organization) }

  before do
    request.env["decidim.current_organization"] = organization
    request.env["decidim.current_participatory_space"] = component.participatory_space
    request.env["decidim.current_component"] = component
    sign_in current_user
  end

  describe "POST #create" do
    context "with all mandatory fields" do
      it "creates a solution" do
        post :create, params: params

        expect(flash[:notice]).not_to be_empty
        expect(response).to have_http_status(:found)
      end
    end

    context "without some mandatory fields" do
      let(:title) do
        {
          en: nil,
          es: nil,
          ca: nil,
        }
      end

      it "doesn't create a solution" do
        post :create, params: params

        expect(flash[:alert]).not_to be_empty
        expect(response).to have_http_status(:ok)
      end
    end

    context "when module problem is active" do
      it "with problem" do
        post :create, params: params

        expect(flash[:notice]).not_to be_empty
        expect(response).to have_http_status(:found)
      end
    end

    context "when module problem is not active" do
      let(:params) do
        {
          solution: {
            title: title,
            description: description,
            author_id: current_user.id,
            decidim_challenges_challenge_id: challenge.id,
            tags: tags,
            objectives: objectives,
            indicators: indicators,
            beneficiaries: beneficiaries,
            financing_type: financing_type,
            requirements: requirements,
          },
          component_id: component,
          scope: scope,
          participatory_process_slug: component.participatory_space.slug,
        }
      end

      it "has a challenge" do
        post :create, params: params

        expect(flash[:notice]).not_to be_empty
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe "PUT #update" do
    let(:solution) { create(:solution, component: component) }

    context "with all mandatory fields with module problems" do
      let(:params) do
        {
          id: solution.id,
          solution: {
            title: {
              en: "Updated solution title",
              es: "Título solución actualizada",
              ca: "Títol solució actualitzada",
            },
            description: description,
            author_id: current_user.id,
            decidim_problems_problem_id: problem.id,
            decidim_challenges_challenge_id: nil,
            tags: tags,
            objectives: objectives,
            indicators: indicators,
            beneficiaries: beneficiaries,
            financing_type: financing_type,
            requirements: requirements,
          },
          component: component,
          scope: scope,
          participatory_process_slug: component.participatory_space.slug,
        }
      end

      it "updates a solution" do
        put :update, params: params

        expect(flash[:notice]).not_to be_empty
        expect(response).to have_http_status(:found)
      end
    end

    context "with all mandatory fields without module problems" do
      let(:params) do
        {
          id: solution.id,
          solution: {
            title: {
              en: "Updated solution title",
              es: "Título solución actualizada",
              ca: "Títol solució actualitzada",
            },
            description: description,
            author_id: current_user.id,
            decidim_problems_problem_id: nil,
            decidim_challenges_challenge_id: challenge.id,
            tags: tags,
            objectives: objectives,
            indicators: indicators,
            beneficiaries: beneficiaries,
            financing_type: financing_type,
            requirements: requirements,
          },
          component: component,
          scope: scope,
          participatory_process_slug: component.participatory_space.slug,
        }
      end

      it "updates a solution" do
        put :update, params: params

        expect(flash[:notice]).not_to be_empty
        expect(response).to have_http_status(:found)
      end
    end

    context "without some mandatory fields" do
      let(:params) do
        {
          id: solution.id,
          problem: {
            title: {
              en: nil,
              es: nil,
              ca: nil,
            },
          },
          component: component,
          scope: scope,
          participatory_process_slug: component.participatory_space.slug,
        }
      end

      it "doesn't update a solution" do
        put :update, params: params

        expect(flash[:alert]).not_to be_empty
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:solution) { create(:solution, component: component) }
    let(:params) do
      {
        id: solution.id,
        component: component,
        scope: scope,
        participatory_process_slug: component.participatory_space.slug,
      }
    end

    it "deletes a solution" do
      delete :destroy, params: params

      expect(flash[:notice]).not_to be_empty
      expect(response).to have_http_status(:found)
    end
  end
end
