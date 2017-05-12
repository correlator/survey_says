class OrdersController < ApplicationController
  before_action :load_order, only: [:show, :edit, :update]
  def index
    @orders = Order.all
    respond_to do |format|
      format.html
      format.json { render json: @orders }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end

  def edit
    respond_to do |format|
      format.js
      format.html
      format.json { render json: @order }
    end
  end

  def create
    @order = Order.new(order_params)
    respond_to do |format|
      if @order.save
        @order.participants = order_participants
        @order.activate! #POC hack.
        format.js
        format.html
        format.json { render json: @order }
      else
        format.js
        format.html { render :new }
        format.json { render json_400(@order) } end
    end
  end

  def update
    @order.update(order_params)
    respond_to do |format|
      if @order.save
        @order.participants = order_participants
        format.js
        format.html
        format.json { render json: @order }
      else
        format.js
        format.html { render :new }
        format.json { render json_400(@order) }
      end
    end
  end

  private

  def order_params
    params.require(:order)
          .permit(:vendor_id, :description, :price_in_cents,
                  :close_date, :status)
  end

  def load_order
    @order = Order.find_by_id(params[:id])
    render_404 if @order.blank?
  end

  def order_participants
    Participant.where(id: params[:order][:participant_ids])
  end
end
