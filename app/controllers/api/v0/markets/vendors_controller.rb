class Api::V0::Markets::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    # require 'pry';binding.pry
    market = Market.find(params[:market_id])
    vendors = market.vendors
    render json: { data: vendors.map { |vendor| format_vendor_as_json_api(vendor) } }
  end

  private
 
  def format_vendor_as_json_api(vendor)
    {
      id: vendor.id.to_s,
      type: 'vendor',
      attributes: {
        name: vendor.name,
        description: vendor.description,
        contact_name: vendor.contact_name,
        contact_phone: vendor.contact_phone,
        credit_accepted: vendor.credit_accepted
      }
    }
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end