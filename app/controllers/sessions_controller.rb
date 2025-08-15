class SessionsController < ApplicationController
  before_action :authenticate_user!, only: %i[destroy]
  def create
    # Login logic
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      api_key = user.api_keys.create!
      render json: { token: api_key.token }, status: :ok
    else
      head :unauthorized
    end
  end

  def destroy
    # Logout logic
    api_key = ApiKey.find_by(token: @current_user.api_keys.first.token)
    if api_key&.bearer
      api_key.bearer.api_keys.destroy_all
    end
    head :no_content
  end

end
