# frozen_string_literal: true

shared_examples "export survey user answers" do
  let!(:questionnaire) { create(:questionnaire) }
  let!(:questions) { create_list(:questionnaire_question, 3, questionnaire:) }
  let!(:answers) do
    questions.map do |question|
      create_list(:answer, 3, questionnaire:, question:)
    end.flatten
  end

  it "exports a CSV" do
    visit_component_admin
    click_on("Survey")
    click_on("Edit survey")

    find(".exports.button").click
    perform_enqueued_jobs { click_on "CSV" }

    within ".flash.success" do
      expect(page).to have_content("in progress")
    end

    expect(last_email.subject).to include("answers", "csv")
    expect(last_email.attachments.length).to be_positive
    expect(last_email.attachments.first.filename).to match(/^answers.*\.zip$/)
  end

  it "exports a JSON" do
    visit_component_admin
    click_on("Survey")
    click_on("Edit survey")

    find(".exports.button").click
    perform_enqueued_jobs { click_on "JSON" }

    within ".flash.success" do
      expect(page).to have_content("in progress")
    end

    expect(last_email.subject).to include("answers", "json")
    expect(last_email.attachments.length).to be_positive
    expect(last_email.attachments.first.filename).to match(/^answers.*\.zip$/)
  end

  it "exports a PDF" do
    visit_component_admin
    click_on("Survey")
    click_on("Edit survey")

    find(".exports.button").click
    perform_enqueued_jobs { click_on "PDF" }

    within ".flash.success" do
      expect(page).to have_content("in progress")
    end

    expect(last_email.subject).to include("answers", "pdf")
    expect(last_email.attachments.length).to be_positive
    expect(last_email.attachments.first.filename).to match(/^answers.*\.zip$/)
  end
end
