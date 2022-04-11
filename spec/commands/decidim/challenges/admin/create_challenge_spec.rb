# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Challenges
    module Admin
      describe CreateChallenge do
        subject { described_class.new(form) }

        let(:organization) { create :organization, available_locales: [:en] }
        let(:current_user) { create :user, :admin, :confirmed, organization: organization }
        let(:participatory_process) { create :participatory_process, organization: organization }
        let(:current_component) { create :component, participatory_space: participatory_process, manifest_name: "challenges" }
        let(:scope) { create :scope, organization: organization }
        let(:sdg_code) { "clean_water" }
        let(:tags) { "tag1, tag2, tag3" }
        let(:state) { 2 }
        let(:start_date) { 2.days.from_now }
        let(:end_date) { 2.days.from_now + 4.hours }
        let(:collaborating_entities) { "collaborating_entities" }
        let(:coordinating_entities) { "coordinating_entities" }
        let(:card_image) { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }
        let(:form) do
          instance_double(
            Decidim::Challenges::Admin::ChallengesForm,
            invalid?: invalid,
            title: { en: "title" },
            local_description: { en: "local desc" },
            global_description: { en: "global desc" },
            tags: tags,
            scope: scope,
            sdg_code: sdg_code,
            state: state,
            start_date: start_date,
            end_date: end_date,
            coordinating_entities: coordinating_entities,
            collaborating_entities: collaborating_entities,
            current_user: current_user,
            current_organization: organization,
            current_component: current_component,
            card_image: card_image
          )
        end
        let(:invalid) { false }

        context "when the form is not valid" do
          let(:invalid) { true }

          it "is not valid" do
            expect { subject.call }.to broadcast(:invalid)
          end
        end

        context "when everything is ok" do
          let(:challenge) { Challenge.last }

          it "creates the challenge" do
            expect { subject.call }.to change(Challenge, :count).by(1)
          end

          it "sets the scope" do
            subject.call
            expect(challenge.scope).to eq scope
          end

          it "sets sdg_code" do
            subject.call
            expect(challenge.sdg_code).to eq(sdg_code)
          end

          it "sets the tags" do
            subject.call
            expect(challenge.tags).to eq(tags)
          end

          it "sets the state" do
            subject.call
            expect(Decidim::Challenges::Challenge.states[challenge.state]).to eq(state)
          end

          it "sets the collaborating_entities and coordinating_entities" do
            subject.call
            expect(challenge.collaborating_entities).to eq(collaborating_entities)
            expect(challenge.coordinating_entities).to eq(coordinating_entities)
          end

          it "sets the component" do
            subject.call
            expect(challenge.component).to eq current_component
          end

          it "sets the questionnaire for survey" do
            subject.call
            expect(challenge.questionnaire).to be_a(Decidim::Forms::Questionnaire)
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:create!)
              .with(Challenge, current_user, kind_of(Hash), visibility: "all")
              .and_call_original

            expect { subject.call }.to change(Decidim::ActionLog, :count)
            action_log = Decidim::ActionLog.last
            expect(action_log.version).to be_present
          end
        end
      end
    end
  end
end
