class Api::V0::MarketsController < ApplicationController 
  before_action :find_market, only: [:show, :nearest_atms]

  def index 
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(@market)
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
    params.permit(:name, :city, :state).to_hash
  end

  def find_market
    @market = Market.find(params[:id])
  end
end