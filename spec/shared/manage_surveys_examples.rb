# frozen_string_literal: true

def visit_edit_survey_page
  within find("tr", text: translated(challenge.title)) do
    page.click_link "Survey"
  end
end

shared_examples "manage surveys" do
  it "enable and configure surveys" do
    visit_edit_survey_page

    within ".edit_challenge" do
      check :challenge_survey_enabled

      click_button "Save"
    end

    expect(page).to have_admin_callout("The challenge survey have been successfully saved.\n×")
  end

  context "when exporting surveys answers", driver: :rack_test do
    let!(:surveys) { create_list :survey, 10, challenge: challenge }

    it "exports a CSV" do
      visit_edit_survey_page

      find(".exports.dropdown").click

      click_link "Answers as CSV"

      expect(page.response_headers["Content-Type"]).to eq("text/csv")
      expect(page.response_headers["Content-Disposition"]).to match(/attachment; filename=.*\.csv/)
    end

    it "exports a JSON" do
      visit_edit_survey_page

      find(".exports.dropdown").click

      click_link "Answers as JSON"

      expect(page.response_headers["Content-Type"]).to eq("text/json")
      expect(page.response_headers["Content-Disposition"]).to match(/attachment; filename=.*\.json/)
    end
  end
end
