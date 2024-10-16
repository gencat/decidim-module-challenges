# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # This controller allows an admin to manage surveys from a challenge
      class SurveysController < Admin::ApplicationController
        include Decidim::Forms::Admin::Concerns::HasQuestionnaireAnswers
        include Decidim::Forms::Admin::Concerns::HasQuestionnaire

        def index
          enforce_permission_to :index, :questionnaire_answers

          @query = paginate(collection)
          @participants = participants(@query)
          @total = participants_query.count_participants
        end

        def edit
          enforce_permission_to :edit, :challenge, challenge: challenge

          @form = ChallengeSurveysForm.from_model(challenge)
        end

        def update
          enforce_permission_to :edit, :challenge, challenge: challenge

          @form = ChallengeSurveysForm.from_params(params).with_context(current_organization: challenge.organization, challenge: challenge)

          UpdateSurveys.call(@form, challenge) do
            on(:ok) do
              flash[:notice] = I18n.t("surveys.update.success", scope: "decidim.challenges.admin")
              redirect_to challenges_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("surveys.update.invalid", scope: "decidim.challenges.admin")
              render action: "edit"
            end
          end
        end

        def export
          enforce_permission_to :export_surveys, :challenge, challenge: challenge

          ExportChallengeSurveys.call(challenge, params[:format], current_user) do
            on(:ok) do |export_data|
              send_data export_data.read, type: "text/#{export_data.extension}", filename: export_data.filename("registrations")
            end
          end
        end

        def export_response
          enforce_permission_to :export_answers, :questionnaire

          session_token = params[:session_token]
          answers = Decidim::Forms::QuestionnaireUserAnswers.for(questionnaire)
          title = t("export_response.title", scope: i18n_scope, token: session_token)
          Decidim::Forms::ExportQuestionnaireAnswersJob.perform_later(current_user, title, answers.select { |a| a.first.session_token == session_token })

          flash[:notice] = t("decidim.admin.exports.notice")

          redirect_back(fallback_location: questionnaire_participant_answers_url(session_token))
        end

        def show
          enforce_permission_to :show, :questionnaire_answers

          @participant = participant(participants_query.participant(params[:session_token]))
        end

        def questionnaire_participants_url
          index_answers_challenge_surveys_path
        end

        def questionnaire_participant_answers_url(session_token)
          show_answers_challenge_surveys_url(session_token: session_token)
        end

        def questionnaire_export_response_url(session_token)
          export_response_challenge_surveys_url(session_token: session_token, format: "pdf")
        end

        def questionnaire_for
          challenge
        end

        def public_url
          Decidim::EngineRouter.main_proxy(current_component).answer_challenge_survey_path(challenge.id)
        end

        private

        def challenge
          @challenge ||= Challenge.where(component: current_component).find(params[:challenge_id])
        end

        def participants_query
          Decidim::Forms::QuestionnaireParticipants.new(questionnaire)
        end
      end
    end
  end
end
