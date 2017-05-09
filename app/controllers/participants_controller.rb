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
      format.js
      format.html
      format.json { render json: @participant }
    end
  end

  def create
    @participant = Participant.new(participant_params)
    respond_to do |format|
      if @participant.update(participant_params)
        format.js
        format.html
        format.json { render json: @participant }
      else
        format.js
        format.html { render :new }
        format.json { render json_400 }
      end
    end
  end

  def update
    @participant.update(participant_params)
    respond_to do |format|
      if @participant.save
        format.js
        format.html
        format.json { render json: @participant }
      else
        format.js
        format.html { render :new }
        format.json { render json_400 }
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

  def json_400
    {
      json: @participant.errors,
      status: :unprocessable_entity
    }
  end
end
