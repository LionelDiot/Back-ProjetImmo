# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  

    def create
      user = User.find_by(email: create_params[:email])
      user&.send_reset_password_instructions
      render json: {}
    end
  
    def update
      user = User.reset_password_by_token(update_params)
      render json: user, status: :ok
    end
  
    private
  
    def create_params
      params.require(:user).permit(:email)
    end
  
    def update_params
      params.require(:user).permit(:password, :password_confirmation, :reset_password_token)
    end
  
end
