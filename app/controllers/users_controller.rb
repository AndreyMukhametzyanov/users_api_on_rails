class UsersController < ApplicationController
  before_action :check_access, except: :index
  def index
    users = User.all
    render json: { status: :ok, data: users }
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { status: :ok, phone: user.phone }
    else
      render json: { status: :error, messages: user.errors.messages }
    end
  end


  def show
    user = User.find_by(phone: params[:phone])

    if user
      render json: { status: :ok, data: user }
    else
      render json: { status: :not_found }
    end
  end

  def update
    user = User.find_by(phone: params[:phone])
    return render json: { status: :not_found } unless user

    if user.update(user_params)
      render json: { status: :ok, data: user }
    else
      render json: { status: :error, messages: user.errors.messages }
    end
  end

  def destroy
    user = User.find_by(phone: params[:phone])
    return render json: { status: :not_found } unless user

    user.destroy
    render json: { status: :ok }
  end

  private

  def user_params
    params.require(:user).permit(:phone, :first_name, :last_name, :date_of_birth, :comment)
  end

end