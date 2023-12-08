class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    # require 'pry';binding.pry
    market = Market.find(params[:market_id])
    vendors = market.vendors
    render json: VendorSerializer.new(vendors)
  end

  # def create
  #   market_vendor = MarketVendor.new(market_vendor_params)

  #   if market_vendor.save 
  #     render json: market_vendor, status: :created
  #   else
  #     render json: ErrorSerializer.new(market_vendor.errors.full_messages), status: :not_found
  #   end
  # end

  def create
    unless Market.exists?(market_vendor_params[:market_id])
      return render json: { errors: [{ detail: 'Market must exist' }] }, status: :not_found # 404
    end

    unless Vendor.exists?(market_vendor_params[:vendor_id])
      return render json: { errors: [{ detail: 'Vendor must exist' }] }, status: :not_found # 404
    end

    market_vendor = MarketVendor.new(market_vendor_params)

    if market_vendor.save
      render json: market_vendor, status: :created # 201
    else
      if market_vendor.errors.details[:market_id].any? { |error| error[:error] == :taken }
        render json: { errors: [{ detail: "Market vendor association between market with market_id=#{market_vendor.market_id} and vendor_id=#{market_vendor.vendor_id} already exists" }] }, status: :unprocessable_entity # 422
      else
        render json: ErrorSerializer.new(market_vendor.errors.full_messages), status: :bad_request # 400
      end
    end
  end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  # def render_success_response
  #   render json: { "message": 'Successfully added vendor to market' }, status: 201
  # end

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end
end