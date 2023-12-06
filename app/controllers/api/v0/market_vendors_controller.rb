class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    # require 'pry';binding.pry
    market = Market.find(params[:market_id])
    vendors = market.vendors
    render json: VendorSerializer.new(vendors)
  end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end