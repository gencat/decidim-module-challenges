# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Solutions
    module Admin
      describe CreateSolution do
        subject { described_class.new(form) }

        let(:organization) { create :organization, available_locales: [:en] }
        let(:current_user) { create :user, :admin, :confirmed, organization: organization }
        let(:participatory_process) { create :participatory_process, organization: organization }
        let(:current_component) { create :component, participatory_space: participatory_process, manifest_name: "solutions" }
        let(:challenge) { create :challenge }
        let(:problem) { create :problem, challenge: challenge }
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
        let(:form) do
          instance_double(
            Decidim::Solutions::Admin::SolutionsForm,
            invalid?: invalid,
            title: { en: "Solution title" },
            description: { en: "Solution desc" },
            decidim_problems_problem_id: problem.id,
            tags: tags,
            objectives: objectives,
            indicators: indicators,
            beneficiaries: beneficiaries,
            financing_type: financing_type,
            requirements: requirements,
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
          let(:solution) { Solution.last }

          it "creates the solution" do
            expect { subject.call }.to change(Solution, :count).by(1)
          end

          it "sets the problem" do
            subject.call
            expect(solution.problem).to eq problem
          end

          it "sets the component" do
            subject.call
            expect(solution.component).to eq current_component
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:create!)
              .with(Solution, current_user, kind_of(Hash), visibility: "all")
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
