# frozen_string_literal: true

require "spec_helper"

describe Decidim::Problems::Admin::ProblemsController, type: :controller do
  routes { Decidim::Problems::AdminEngine.routes }

  let(:organization) { create :organization, available_locales: [:en] }
  let(:title) do
    {
      en: "Problem title",
      es: "Título problema",
      ca: "Títol problema",
    }
  end
  let(:description) do
    {
      en: "Problem description",
      es: "Descripción problema",
      ca: "Descripció problema",
    }
  end
  let(:challenge) { create :challenge }
  let(:tags) { "tag1, tag2, tag3" }
  let(:causes) { "causes" }
  let(:groups_affected) { "groups affected" }
  let(:start_date) { 2.days.from_now.strftime("%d/%m/%Y") }
  let(:end_date) { (2.days.from_now + 4.hours).strftime("%d/%m/%Y") }
  let(:collaborating_entities) { "collaborating_entities" }
  let(:proposing_entities) { "proposing_entities" }
  let(:state) { 2 }
  let(:params) do
    {
      problem: {
        title: title,
        description: description,
        state: state,
        decidim_challenges_challenge_id: challenge.id,
        tags: tags,
        causes: causes,
        groups_affected: groups_affected,
        start_date: start_date,
        end_date: end_date,
        collaborating_entities: collaborating_entities,
        proposing_entities: proposing_entities,
      },
      component_id: component,
      scope: scope,
      participatory_process_slug: component.participatory_space.slug,
    }
  end
  let(:current_user) { create :user, :admin, :confirmed, organization: organization }
  let(:participatory_process) { create :participatory_process, organization: organization }
  let(:component) { create :component, participatory_space: participatory_process, manifest_name: "problems", organization: organization }
  let(:scope) { create :scope, organization: organization }

  before do
    request.env["decidim.current_organization"] = organization
    request.env["decidim.current_participatory_space"] = component.participatory_space
    request.env["decidim.current_component"] = component
    sign_in current_user
  end

  describe "POST #create" do
    context "with all mandatory fields" do
      it "creates a problem" do
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

      it "doesn't create a problem" do
        post :create, params: params

        expect(flash[:alert]).not_to be_empty
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PUT #update" do
    let(:problem) { create :problem, component: component }

    context "with all mandatory fields" do
      let(:params) do
        {
          id: problem.id,
          problem: {
            title: {
              en: "Updated problem title",
              es: "Título problema actualizado",
              ca: "Títol problema actualitzat",
            },
            description: description,
            state: state,
            decidim_challenges_challenge_id: challenge.id,
            tags: tags,
            causes: causes,
            groups_affected: groups_affected,
            start_date: start_date,
            end_date: end_date,
            collaborating_entities: collaborating_entities,
            proposing_entities: proposing_entities,
          },
          component: component,
          scope: scope,
          participatory_process_slug: component.participatory_space.slug,
        }
      end

      it "updates a problem" do
        put :update, params: params

        expect(flash[:notice]).not_to be_empty
        expect(response).to have_http_status(:found)
      end
    end

    context "without some mandatory fields" do
      let(:params) do
        {
          id: problem.id,
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

      it "doesn't update a problem" do
        put :update, params: params

        expect(flash[:alert]).not_to be_empty
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:problem) { create :problem, component: component }
    let(:params) do
      {
        id: problem.id,
        component: component,
        scope: scope,
        participatory_process_slug: component.participatory_space.slug,
      }
    end

    it "deletes a problem" do
      delete :destroy, params: params

      expect(flash[:notice]).not_to be_empty
      expect(response).to have_http_status(:found)
    end
  end
end
