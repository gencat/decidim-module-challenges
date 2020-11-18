# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Problems
    module Admin
      describe CreateProblem do
        subject { described_class.new(form) }

        let(:organization) { create :organization, available_locales: [:en] }
        let(:current_user) { create :user, :admin, :confirmed, organization: organization }
        let(:participatory_process) { create :participatory_process, organization: organization }
        let(:current_component) { create :component, participatory_space: participatory_process, manifest_name: "problems" }
        let(:challenge) { create :challenge }
        let(:scope) { create :scope, organization: organization }
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
            title: { en: "Problem title" },
            description: { en: "Problem desc" },
            decidim_challenges_challenge_id: challenge.id,
            scope: scope,
            tags: tags,
            causes: causes,
            groups_affected: groups_affected,
            state: state,
            start_date: start_date,
            end_date: end_date,
            proposing_entities: proposing_entities,
            collaborating_entities: collaborating_entities,
            current_user: current_user,
            current_organization: organization,
            current_component: current_component
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
          let(:problem) { Problem.last }

          it "creates the problem" do
            expect { subject.call }.to change(Problem, :count).by(1)
          end

          it "sets the scope" do
            subject.call
            expect(problem.scope).to eq scope
          end

          it "sets the challenge" do
            subject.call
            expect(problem.challenge).to eq challenge
          end

          it "sets the component" do
            subject.call
            expect(problem.component).to eq current_component
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:create!)
              .with(Problem, current_user, kind_of(Hash), visibility: "all")
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
