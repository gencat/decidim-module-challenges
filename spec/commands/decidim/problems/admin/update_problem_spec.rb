# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Problems
    module Admin
      describe UpdateProblem do
        subject { described_class.new(form, problem) }

        let(:organization) { create(:organization, available_locales: [:en]) }
        let(:current_user) { create(:user, :admin, :confirmed, organization:) }
        let(:participatory_process) { create(:participatory_process, organization:) }
        let(:current_component) { create(:component, participatory_space: participatory_process, manifest_name: "problems") }
        let(:challenge) { create(:challenge) }
        let(:sectorial_scope) { create(:scope, organization:) }
        let(:technological_scope) { create(:scope, organization:) }
        let(:title) { "Problem title" }
        let(:tags) { "tag1, tag2, tag3" }
        let(:causes) { "causes" }
        let(:groups_affected) { "groups affected" }
        let(:state) { 2 }
        let(:start_date) { 2.days.from_now }
        let(:end_date) { 2.days.from_now + 4.hours }
        let(:proposing_entities) { "proposing_entities" }
        let(:collaborating_entities) { "collaborating_entities" }
        let(:form) do
          instance_double(
            Decidim::Problems::Admin::ProblemsForm,
            invalid?: invalid,
            title: { en: title },
            description: { en: "Problem desc" },
            decidim_challenges_challenge_id: challenge.id,
            decidim_sectorial_scope_id: sectorial_scope.id,
            decidim_technological_scope_id: technological_scope.id,
            tags:,
            causes:,
            groups_affected:,
            state:,
            start_date:,
            end_date:,
            proposing_entities:,
            collaborating_entities:,
            current_user:,
            current_organization: organization,
            current_component:
          )
        end
        let(:invalid) { false }
        let(:problem) { create(:problem) }

        context "when the form is not valid" do
          let(:invalid) { true }

          it "is not valid" do
            expect { subject.call }.to broadcast(:invalid)
          end
        end

        context "when everything is ok" do
          it "updates the problem" do
            subject.call
            expect(translated(problem.title)).to eq title
          end

          it "sets the sectorial scope" do
            subject.call
            expect(problem.decidim_sectorial_scope_id).to eq sectorial_scope.id
          end

          it "sets the technological scope" do
            subject.call
            expect(problem.decidim_technological_scope_id).to eq technological_scope.id
          end

          it "sets challenge" do
            subject.call
            expect(problem.challenge).to eq(challenge)
          end

          it "sets the tags" do
            subject.call
            expect(problem.tags).to eq(tags)
          end

          it "sets the state" do
            subject.call
            expect(Decidim::Problems::Problem.states[problem.state]).to eq(state)
          end

          it "sets the collaborating_entities and proposing_entities" do
            subject.call
            expect(problem.collaborating_entities).to eq(collaborating_entities)
            expect(problem.proposing_entities).to eq(proposing_entities)
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:update!)
              .with(problem, current_user, kind_of(Hash))
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
