class UsersController < ApplicationController
  def index
    users = User.all
    render json: { status: :ok, data: users }
  end

  def create
    user = User.new(users_params)
    if user.save
      render json: { status: :ok, phone: user.phone }
    else
      render json: { status: :error, messages: user.errors.messages }
    end
  end

  def update
    user = User.find_by(phone: params[:phone])
    return render json: { status: :not_found } unless user

    if user.update(users_params)
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

  def show_by_phone
    user = User.find_by(phone: params[:phone])

    if user
      render json: { status: :ok, data: user }
    else
      render json: { status: :not_found }
    end
  end

  private

  def users_params
    params.require(:user).permit(:phone, :first_name, :last_name, :date_of_birth, :comment)
  end

end