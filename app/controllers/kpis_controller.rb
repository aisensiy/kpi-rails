class KpisController < ApplicationController
  before_filter :authenticate

  def index
    @kpis = Kpi.all
    render json: @kpis
  end

  def create
    authorize! :create, Kpi.new
    if kpi_params[:type] == 'member'
      kpi = Kpi.new(from: kpi_params[:from], to: kpi_params[:to], category: kpi_params[:category], member_id: kpi_params[:member_id])
    else
      kpi = Kpi.new(from: kpi_params[:from], to: kpi_params[:to], category: kpi_params[:category], team_id: kpi_params[:team_id])
    end

    if kpi.save
      render nothing: true, status: :created, location: kpi
    else
      render nothing: true, status: 400
    end
  end

  def show
    @kpi = Kpi.find(params[:id])
  end

  private
  def kpi_params
    params.require(:kpi).permit(:from, :to, :kpi, :category, :member_id, :team_id)
  end
end
