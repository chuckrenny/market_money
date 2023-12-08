class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def show
    vendor = Vendor.find(params[:id])
    render json: VendorSerializer.new(vendor)
  end

  def create
    vendor = Vendor.new(vendor_params)

    if vendor.save
      render json: VendorSerializer.new(vendor), status: :created
    else
      # render json: { errors: vendor.errors.full_messages }, status: :bad_request # hand roll
      render json: ErrorSerializer.new(vendor.errors.full_messages), status: :bad_request
    end
  end

  def update
    # require 'pry';binding.pry
    vendor = Vendor.find(params[:id])

    if vendor.update(vendor_params)
      render json: VendorSerializer.new(vendor), status: :created
    else
      render json: { errors: vendor.errors.full_messages }, status: :bad_request # 400
      # render json: ErrorSerializer.new(vendor.errors.full_messages), status: :bad_request
    end
  end

  def destroy
    vendor = Vendor.find(params[:id])
    vendor.destroy
    head :no_content
  end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end