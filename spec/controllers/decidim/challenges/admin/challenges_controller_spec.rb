# frozen_string_literal: true

require "spec_helper"

describe Decidim::Challenges::Admin::ChallengesController, type: :controller do
  routes { Decidim::Challenges::AdminEngine.routes }

  let(:organization) { create :organization, available_locales: [:en] }
  let(:title) do
    {
      en: "Challenge title",
      es: "Título reto",
      ca: "Títol repte",
    }
  end
  let(:local_description) do
    {
      en: "Local description",
      es: "Descripción local",
      ca: "Descripció local",
    }
  end
  let(:global_description) do
    {
      en: "Global description",
      es: "Descripción global",
      ca: "Descripció global",
    }
  end
  let(:sdg_code) { Decidim::Sdgs::Sdg::SDGS.first }
  let(:tags) { "tag1, tag2, tag3" }
  let(:start_date) { 2.days.from_now.strftime("%d/%m/%Y") }
  let(:end_date) { (2.days.from_now + 4.hours).strftime("%d/%m/%Y") }
  let(:collaborating_entities) { "collaborating_entities" }
  let(:coordinating_entities) { "coordinating_entities" }
  let(:state) { 2 }
  let(:card_image) { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }
  let(:params) do
    {
      challenge: {
        title: title,
        local_description: local_description,
        global_description: global_description,
        state: state,
        sdg_code: sdg_code,
        tags: tags,
        start_date: start_date,
        end_date: end_date,
        collaborating_entities: collaborating_entities,
        coordinating_entities: coordinating_entities,
        card_image: card_image,
      },
      component_id: component,
      scope: scope,
      participatory_process_slug: component.participatory_space.slug,
    }
  end
  let(:current_user) { create :user, :admin, :confirmed, organization: organization }
  let(:participatory_process) { create :participatory_process, organization: organization }
  let(:component) { create :component, participatory_space: participatory_process, manifest_name: "challenges", organization: organization }
  let(:scope) { create :scope, organization: organization }

  before do
    request.env["decidim.current_organization"] = organization
    request.env["decidim.current_participatory_space"] = component.participatory_space
    request.env["decidim.current_component"] = component
    sign_in current_user
  end

  describe "POST #create" do
    context "with all mandatory fields" do
      it "creates a challenge" do
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

      it "doesn't create a challenge" do
        post :create, params: params

        expect(flash[:alert]).not_to be_empty
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PUT #update" do
    let(:challenge) { create :challenge, component: component }

    context "with all mandatory fields" do
      let(:params) do
        {
          id: challenge.id,
          challenge: {
            title: {
              en: "Updated challenge title",
              es: "Título reto actualizado",
              ca: "Títol repte actualitzat",
            },
            local_description: local_description,
            global_description: global_description,
            state: state,
            sdg_code: sdg_code,
            tags: tags,
            start_date: start_date,
            end_date: end_date,
            collaborating_entities: collaborating_entities,
            coordinating_entities: coordinating_entities,
          },
          component: component,
          scope: scope,
          participatory_process_slug: component.participatory_space.slug,
        }
      end

      it "updates a challenge" do
        put :update, params: params

        expect(flash[:notice]).not_to be_empty
        expect(response).to have_http_status(:found)
      end
    end

    context "without some mandatory fields" do
      let(:params) do
        {
          id: challenge.id,
          challenge: {
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

      it "doesn't update a challenge" do
        put :update, params: params

        expect(flash[:alert]).not_to be_empty
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:challenge) { create :challenge, component: component }
    let(:params) do
      {
        id: challenge.id,
        component: component,
        scope: scope,
        participatory_process_slug: component.participatory_space.slug,
      }
    end

    it "deletes a challenge" do
      delete :destroy, params: params

      expect(flash[:notice]).not_to be_empty
      expect(response).to have_http_status(:found)
    end
  end
end
