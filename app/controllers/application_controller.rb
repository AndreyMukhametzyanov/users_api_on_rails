class ApplicationController < ActionController::API
  PATH = 'http://127.0.0.1:4000/check_access'

  def check_access
    result = JSON.parse(RestClient.post(PATH, { phone: params[:phone], method: params[:method] }.to_json, { content_type: :json, accept: :json }).body)
                 .with_indifferent_access
                 .fetch(:result)
    Rails.logger.info("Result = #{result}")
    Rails.logger.info("phone #{params[:phone]}")
    Rails.logger.info("method #{params[:method]}")

  end
end
