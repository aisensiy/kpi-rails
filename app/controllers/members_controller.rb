class MembersController < ApplicationController
  respond_to :json

  def show
    @member = Member.find(params[:id])
  end

  def create
    @member = Member.new member_params
    if @member.save
      render nothing: true, status: :created, location: @member
    else
      render nothing: true, status: 400
    end
  end

  def login
    member = Member.find_by(name: login_params[:name])
    if member && member.authenticate(login_params[:password])
      session[:user_id] = member.id
      render nothing: true, status: 200
    else
      render nothing: true, status: 400
    end
  end

  def logout
    session[:user_id] = nil
    render nothing: true, status: 200
  end

  private
  def member_params
    params.require(:member).permit(:name, :password, :role)
  end

  def login_params
    params.permit(:name, :password)
  end
end