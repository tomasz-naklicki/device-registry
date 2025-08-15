class UsersController < ApplicationController
  
  def create
    user = User.new(user_params)
    if user.save
      api_key = user.api_keys.create!
      render json: { token: api_key.token, user: { id: user.id, email: user.email } }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
