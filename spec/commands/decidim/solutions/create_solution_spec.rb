# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Solutions
    describe CreateSolution do
      subject { described_class.new(form) }

      let(:organization) { create(:organization, available_locales: [:en]) }
      let(:current_user) { create(:user, :confirmed, organization:) }
      let(:participatory_process) { create(:participatory_process, organization:) }
      let(:current_component) { create(:component, participatory_space: participatory_process, manifest_name: "solutions") }
      let(:challenge) { create(:challenge) }
      let(:project_status) { "in_progress" }
      let(:project_url) { "http://test.example.org" }
      let(:coordinating_entity) { "Coordinating entity" }
      let(:uploaded_files) { [] }

      let(:form) do
        instance_double(
          Decidim::Solutions::SolutionsForm,
          invalid?: invalid,
          title: { en: "Solution title" },
          description: { en: "Solution desc" },
          author_id: current_user.id,
          decidim_challenges_challenge_id: challenge.id,
          decidim_problems_problem_id: nil,
          project_status:,
          project_url:,
          coordinating_entity:,
          current_user:,
          current_organization: organization,
          current_component:,
          add_documents: uploaded_files,
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

        it "sets the challenge" do
          subject.call
          expect(solution.challenge).to eq challenge
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
