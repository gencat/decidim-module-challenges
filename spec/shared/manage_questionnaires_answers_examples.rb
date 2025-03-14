# frozen_string_literal: true

require "spec_helper"

shared_examples_for "manage questionnaire answers" do
  let(:first_type) { "short_answer" }
  let!(:first) do
    create(:questionnaire_question, questionnaire:, position: 1, question_type: first_type)
  end
  let!(:second) do
    create(:questionnaire_question, questionnaire:, position: 2, question_type: "single_option")
  end
  let(:questions) do
    [first, second]
  end

  context "when there are no answers" do
    it "do not answer admin link" do
      visit questionnaire_edit_path
      click_on("Survey")
      click_on("Edit survey")
      expect(page).to have_content("No answers yet")
    end
  end

  context "when there are answers" do
    let!(:answer_1) { create(:answer, questionnaire:, question: first) }
    let!(:answer_2) { create(:answer, body: "second answer", questionnaire:, question: first) }
    let!(:answer_3) { create(:answer, questionnaire:, question: second) }

    it "shows the answer admin link" do
      visit questionnaire_edit_path
      click_on("Survey")
      click_on("Edit survey")
      expect(page).to have_content("Show responses")
    end

    context "and managing answers page" do
      before do
        visit questionnaire_edit_path
        click_on("Survey")
        click_on("Edit survey")
        click_on "Show responses"
      end

      it "shows the anwers page" do
        expect(page).to have_content(answer_1.body)
        expect(page).to have_content(answer_1.question.body["en"])
        expect(page).to have_content(answer_2.body)
        expect(page).to have_content(answer_2.question.body["en"])
      end

      it "shows the percentage" do
        expect(page).to have_content("50%")
      end

      it "has a detail link" do
        expect(page).to have_link("Show answers")
      end

      it "has an export link" do
        expect(page).to have_link(answer_1.body)
        expect(page).to have_link(answer_2.body)
        expect(page).to have_link("Export")
      end

      context "when no short answer exist" do
        let(:first_type) { "long_answer" }

        it "shows session token" do
          expect(page).to have_no_content(answer_1.body)
          expect(page).to have_content(answer_1.session_token)
          expect(page).to have_content(answer_2.session_token)
          expect(page).to have_content(answer_3.session_token)
          expect(page).to have_content("User identifier")
        end
      end
    end

    context "and managing individual answer page" do
      let!(:answer_11) { create(:answer, questionnaire:, body: "", user: answer_1.user, question: second) }

      before do
        visit questionnaire_edit_path
        click_on("Survey")
        click_on("Edit survey")
        click_on "Show responses"
      end

      it "shows all the questions and responses" do
        click_on answer_1.body, match: :first
        expect(page).to have_content(first.body["en"])
        expect(page).to have_content(second.body["en"])
        expect(page).to have_content(answer_1.body)
      end

      it "first answer has a next link" do
        click_on answer_1.body, match: :first
        expect(page).to have_link("Next ›")
        expect(page).to have_no_link("‹ Prev")
      end

      it "second answer has prev/next links" do
        click_on answer_2.body, match: :first
        expect(page).to have_link("Next ›")
        expect(page).to have_link("‹ Prev")
      end

      it "third answer has prev link" do
        click_on answer_3.session_token, match: :first
        expect(page).to have_no_link("Next ›")
        expect(page).to have_link("‹ Prev")
      end
    end
  end
end
