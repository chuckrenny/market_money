class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    markets = Market.all
    render json: MarketSerializer.new(markets)
  end
  
  def show
    market = Market.find(params[:id])
    render json: MarketSerializer.new(market)
  end

  private
 
  # def format_market_to_json_api(market)
  #   {
  #     id: market.id.to_s,
  #     type: 'market',
  #     attributes: {
  #       name: market.name,
  #       street: market.street,
  #       city: market.city,
  #       county: market.county,
  #       state: market.state,
  #       zip: market.zip,
  #       lat: market.lat,
  #       lon: market.lon,
  #       vendor_count: market.vendor_count
  #     }
  #   }
  # end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end