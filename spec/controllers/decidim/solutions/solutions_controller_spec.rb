# frozen_string_literal: true

require "spec_helper"

describe Decidim::Solutions::SolutionsController do
  routes { Decidim::Solutions::Engine.routes }

  let(:organization) { create(:organization, available_locales: [:en]) }
  let(:title) { "Títol solució" }
  let(:description) { "Descripció solució" }
  let(:challenge) { create(:challenge) }
  let(:project_status) { "in_progress" }
  let(:project_url) { "http://test.example.org" }
  let(:coordinating_entity) { "Coordinating entity" }
  let(:uploaded_files) { [] }
  let(:params) do
    {
      solution: {
        title:,
        description:,
        author_id: current_user.id,
        decidim_challenges_challenge_id: challenge.id,
        decidim_problems_problem_id: nil,
        project_status:,
        project_url:,
        coordinating_entity:,
        add_documents: uploaded_files,
      },
      component_id: component,
      scope:,
      participatory_process_slug: component.participatory_space.slug,
    }
  end
  let(:current_user) { create(:user, :confirmed, organization:) }
  let(:participatory_process) { create(:participatory_process, organization:) }
  let(:component) { create(:component, participatory_space: participatory_process, manifest_name: "solutions", organization:, settings: { creation_enabled: true }) }
  let(:scope) { create(:scope, organization:) }

  before do
    request.env["decidim.current_organization"] = organization
    request.env["decidim.current_participatory_space"] = component.participatory_space
    request.env["decidim.current_component"] = component
    sign_in current_user
  end

  describe "POST #create" do
    context "with all mandatory fields" do
      it "creates a solution" do
        post(:create, params:)

        expect(flash[:notice]).not_to be_empty
        expect(response).to have_http_status(:found)
      end
    end

    context "without some mandatory fields" do
      let(:title) { nil }

      it "doesn't create a solution" do
        post(:create, params:)

        expect(flash[:alert]).not_to be_empty
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
