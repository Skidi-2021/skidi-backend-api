class HomeController < ApplicationController
    def index
        home
    end

    private

    def home
        if not signed_in?
            render json: {
                errors: { message: "Anda tidak diizinkan untuk mengakses API ini !", http_status: 401 }
            }, status: 401
        else
            render json: {
                success: { message: "Selamat datang di API Skidi Skin Disease", http_status: 200 }
            }, status: 200
        end
    end
end