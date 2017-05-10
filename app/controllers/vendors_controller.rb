class VendorsController < ApplicationController
  before_action :load_vendor, only: [:show, :edit, :update]
  def index
    @vendors = Vendor.all
    respond_to do |format|
      format.html
      format.json { render json: @vendors }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @vendor }
    end
  end

  def edit
    respond_to do |format|
      format.js
      format.html
      format.json { render json: @vendor }
    end
  end

  def create
    @vendor = Vendor.new(vendor_params)
    respond_to do |format|
      if @vendor.update(vendor_params)
        format.js
        format.html
        format.json { render json: @vendor }
      else
        format.js
        format.html { render :new }
        format.json { render json_400 }
      end
    end
  end

  def update
    @vendor.update(vendor_params)
    respond_to do |format|
      if @vendor.save
        format.js
        format.html
        format.json { render json: @vendor }
      else
        format.js
        format.html { render :new }
        format.json { render json_400 }
      end
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name)
  end

  def load_vendor
    @vendor = Vendor.find_by_id(params[:id])
    render_404 if @vendor.blank?
  end

  def json_400
    {
      json: @vendor.errors,
      status: :unprocessable_entity
    }
  end
end
