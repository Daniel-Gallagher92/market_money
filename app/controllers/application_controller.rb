class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_response
  rescue_from ActionController::BadRequest, with: :bad_request_response

  def not_found_response(error)
    render json: ErrorSerializer.new(error).serialized_json, status: :not_found
  end

  def invalid_response(error)
    return not_found_response(error) if error.message.include?('must exist') #finally using some guard clauses in my code!
    return bad_request_response(error) if error.message.include?('blank')
    render json: ErrorSerializer.new(error).serialized_json, status: :unprocessable_entity
  end

  def bad_request_response(error)
    render json: ErrorSerializer.new(error).serialized_json, status: :bad_request
  end
end
