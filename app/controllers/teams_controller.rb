class TeamsController < ApplicationController
  respond_to :json
  before_filter :authenticate

  def index
    @teams = Team.all
  end

  def create
    authorize! :create, Team.new
    team = Team.new(team_params)
    if team.save
      render nothing: true, status: :created, location: team
    else
      render nothing: true, status: :bad_request
    end
  end

  def show
    @team = Team.find(params[:id])
    if @team.nil?
      render nothing: true, status: 404
      return
    end
  end

  private
  def team_params
    params.require(:team).permit([:name])
  end
end
