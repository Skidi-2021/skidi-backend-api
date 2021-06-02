# frozen_string_literal: true

class Auth::RegistrationsController < Devise::RegistrationsController

    include Helpers::ApiHelper

    def create
        user = User.new(resource_params)
        if password_match_validation?
            if user.save
                # iat (Issued At): Waktu dimana JWT ini di berikan ke pengguna
                # jti (JWT ID): Id hasil dari payload iat dan personal token sebagai identifikasi Token JWT
                iat = Time.now.to_i
                jti = Digest::MD5.hexdigest("#{iat}:#{user.personal_token}")
        
                payload = {
                    id: user.id,
                    email: user.email,
                    jti: jti,
                    iat: iat        
                }
                encoded = JsonWebToken.encode(payload)

                render json: auth_response(user.id, user.email, encoded)
            else
                render json: { warning: user.errors.full_messages[0] }, status: 422 # Unprocessable Entity
            end
        else
            render json: { 
                warning: "Password tidak valid. Pastikan password terdiri dari: Minimum 8 karakter, 1 kapital, 1 angka dan 1 karakter unik. Contoh: (Ghaniy98)" }, 
                status: 422
        end
    end

    private

    def resource_params
        params.require(:user).permit(:email, :password, :username, :full_name, :gender, :birthday, :phone, :avatar)
    end
    
end