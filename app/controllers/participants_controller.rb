class ParticipantsController < ApplicationController
  before_action :load_participant, only: [:show, :edit, :update]
  def index
    @participants = Participant.all
    respond_to do |format|
      format.html
      format.json { render json: @participants }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @participant }
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render json: @participant }
    end
  end

  def create
    @participant = Participant.new(participant_params)
    respond_to do |format|
      if @participant.save
        format.html
        format.json { render json: @participant }
      else
        format.html { render :new }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def participant_params
    params.require(:participant).permit(:name, :phone, :email)
  end

  def load_participant
    @participant = Participant.find_by_id(params[:id])
    render_404 if @participant.blank?
  end
end
