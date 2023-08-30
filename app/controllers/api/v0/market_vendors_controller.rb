class Api::V0::MarketVendorsController < ApplicationController 
  def create 
    begin
      market_vendor = MarketVendor.create!(market_vendor_params)
      render json: MarketVendorSerializer.new(market_vendor), status: :created
    rescue ActionController::ParameterMissing => e
      render json: ErrorSerializer.new(e).serialized_json, status: :bad_request
    rescue ActiveRecord::RecordInvalid => e
      error_message(e)
    end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end

  def error_message(e)
    if e.message.include?("must exist")
      render json: ErrorSerializer.new(e).serialized_json, status: :not_found
    elsif e.message.include?("Market vendor")
      render json: ErrorSerializer.new(e).serialized_json, status: :unprocessable_entity
    end
  end
end