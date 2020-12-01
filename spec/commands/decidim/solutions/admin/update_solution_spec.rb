# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Solutions
    module Admin
      describe UpdateSolution do
        subject { described_class.new(form, solution) }

        let(:organization) { create :organization, available_locales: [:en] }
        let(:current_user) { create :user, :admin, :confirmed, organization: organization }
        let(:participatory_process) { create :participatory_process, organization: organization }
        let(:current_component) { create :component, participatory_space: participatory_process, manifest_name: "solutions" }
        let(:challenge) { create :challenge }
        let(:problem) { create :problem, challenge: challenge }
        let(:scope) { create :scope, organization: organization }
        let(:title) { "Solution title" }
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
            title: { en: title },
            description: { en: "Solution desc" },
            decidim_problems_problem_id: problem.id,
            scope: scope,
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
        let(:solution) { create :solution }

        context "when the form is not valid" do
          let(:invalid) { true }

          it "is not valid" do
            expect { subject.call }.to broadcast(:invalid)
          end
        end

        context "when everything is ok" do
          it "updates the solution" do
            subject.call
            expect(translated(solution.title)).to eq title
          end

          it "sets the scope" do
            subject.call
            expect(solution.scope).to eq scope
          end

          it "sets problem" do
            subject.call
            expect(solution.problem).to eq(problem)
          end

          it "sets the tags" do
            subject.call
            expect(solution.tags).to eq(tags)
          end

          it "sets the requirements, objectives, indicators, beneficiaries and financing_type" do
            subject.call
            expect(translated(solution.requirements)).to eq(requirements[:en])
            expect(translated(solution.objectives)).to eq(objectives[:en])
            expect(translated(solution.indicators)).to eq(indicators[:en])
            expect(translated(solution.beneficiaries)).to eq(beneficiaries[:en])
            expect(translated(solution.financing_type)).to eq(financing_type[:en])
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:update!)
              .with(solution, current_user, kind_of(Hash))
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
