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
    click_on("Manage questions")

    find(".exports").click
    expect(Decidim::PrivateExport.count).to eq(0)

    perform_and_wait_for_enqueued_jobs { click_on "CSV" }

    within ".flash.success" do
      expect(page).to have_content("in progress")
    end

    expect(last_email.subject).to eq('Your export "answers" is ready')
    expect(Decidim::PrivateExport.count).to eq(1)
    expect(Decidim::PrivateExport.last.export_type).to eq("answers")
  end

  it "exports a JSON" do
    visit_component_admin
    click_on("Survey")
    click_on("Manage questions")

    find(".exports").click
    expect(Decidim::PrivateExport.count).to eq(0)

    perform_and_wait_for_enqueued_jobs { click_on "JSON" }

    within ".flash.success" do
      expect(page).to have_content("in progress")
    end

    expect(last_email.subject).to eq('Your export "answers" is ready')
    expect(Decidim::PrivateExport.count).to eq(1)
    expect(Decidim::PrivateExport.last.export_type).to eq("answers")
  end

  it "exports a PDF" do
    visit_component_admin
    click_on("Survey")
    click_on("Manage questions")

    find(".exports").click
    expect(Decidim::PrivateExport.count).to eq(0)

    perform_and_wait_for_enqueued_jobs { click_on "PDF" }

    within ".flash.success" do
      expect(page).to have_content("in progress")
    end

    expect(last_email.subject).to eq('Your export "answers" is ready')
    expect(Decidim::PrivateExport.count).to eq(1)
    expect(Decidim::PrivateExport.last.export_type).to eq("answers")
  end

  private

  # There is a chance of a flaky spec here, as sometimes the jobs are not enqueued in the correct order
  # causing user's confirmations to be sent after the export is ready
  def perform_and_wait_for_enqueued_jobs(only: nil, except: nil, queue: nil, at: nil, &block)
    while enqueued_jobs.size.positive?
      perform_enqueued_jobs
      sleep 0.5
    end

    perform_enqueued_jobs(only:, except:, queue:, at:, &block)

    while enqueued_jobs.size.positive?
      perform_enqueued_jobs
      sleep 0.5
    end
  end
end
