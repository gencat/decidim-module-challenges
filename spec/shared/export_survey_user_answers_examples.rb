# frozen_string_literal: true

shared_examples "export survey user answers" do
  let!(:questionnaire) { create(:questionnaire) }
  let!(:questions) { create_list :questionnaire_question, 3, questionnaire: questionnaire }
  let!(:answers) do
    questions.map do |question|
      create_list :answer, 3, questionnaire: questionnaire, question: question
    end.flatten
  end

  it "exports a CSV" do
    visit_component_admin
    click_link("Survey")
    click_link("Edit survey")

    find(".exports.dropdown").click
    perform_enqueued_jobs { click_link "CSV" }

    within ".callout.success" do
      expect(page).to have_content("in progress")
    end

    expect(last_email.subject).to include("answers", "csv")
    expect(last_email.attachments.length).to be_positive
    expect(last_email.attachments.first.filename).to match(/^answers.*\.zip$/)
  end

  it "exports a JSON" do
    visit_component_admin
    click_link("Survey")
    click_link("Edit survey")

    find(".exports.dropdown").click
    perform_enqueued_jobs { click_link "JSON" }

    within ".callout.success" do
      expect(page).to have_content("in progress")
    end

    expect(last_email.subject).to include("answers", "json")
    expect(last_email.attachments.length).to be_positive
    expect(last_email.attachments.first.filename).to match(/^answers.*\.zip$/)
  end

  it "exports a PDF" do
    visit_component_admin
    click_link("Survey")
    click_link("Edit survey")

    find(".exports.dropdown").click
    perform_enqueued_jobs { click_link "PDF" }

    within ".callout.success" do
      expect(page).to have_content("in progress")
    end

    expect(last_email.subject).to include("answers", "pdf")
    expect(last_email.attachments.length).to be_positive
    expect(last_email.attachments.first.filename).to match(/^answers.*\.zip$/)
  end
end
