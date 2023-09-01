class Api::V0::MarketsController < ApplicationController 

  def index 
    render json: MarketSerializer.new(Market.all)
  end

  def show
    begin
      render json: MarketSerializer.new(Market.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.new(e).serialized_json, status: :not_found
    end
  end

  def search
    markets = Market.search(search_params)
    if markets.class != ErrorMarket
      render json: MarketSerializer.new(markets)
    else 
      render json: ErrorSerializer.new(markets).serialized_json, status: :unprocessable_entity
    end
  end

  def nearest_atms 
    begin
      market = Market.find(params[:id])
      atms = NearestAtmFacade.nearest_atm(market.lat, market.lon).compact
      render json: AtmSerializer.new(atms), status: :ok
    rescue StandardError => e
      render json: ErrorSerializer.new(e).serialized_json, status: :not_found
    end
  end

  private

  def search_params
    params.permit(:name, :city, :state)
  end

end