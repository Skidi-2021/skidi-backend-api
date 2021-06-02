class UsersController < ApplicationController
    before_action :authenticate_user!
    
    def show
        user = User.find(params[:id])
        render json: user_response(user), status: 200
    end

    private

    def user_response(user)
        {
            user: {
                username: user.username,
                email: user.email,
                name: user.full_name,
                url: avatar_url(user)
            }
        }
    end

    def avatar_url(user)
        if user.avatar.attached?
            rails_service_blob_url(filename: user.avatar.filename, signed_id: user.avatar.signed_id)
        else
            "No Avatar Found"
        end
    end
end