class OrderParticipantsController < ApplicationController
  before_action :load_order_participant, only: [:show, :update]
  def show
    respond_to do |format|
      format.html
      format.json { render json: @order_participant }
    end
  end

  def update
    @order_participant.update(status: 'approved')
    redirect_to order_participant_url(@order_participant)
  end

  private

  def load_order_participant
    @order_participant = OrderParticipant.find_by_id(params[:id])
    render_404 if @order_participant.blank?
  end
end
