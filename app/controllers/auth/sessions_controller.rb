# frozen_string_literal: true

class Auth::SessionsController < Devise::SessionsController
    skip_before_action :verify_signed_out_user

    include Helpers::ApiHelper
    
    # Method create ini digunakan untuk membuat sesi (proses login user)
    def create
        user = User.find_by_email(email)
  
        if user && user.valid_password?(password)
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
            render json: { warning: "Email atau Password salah" }, status: 422      
        end
    end

    # Method destroy digunakan untuk merevoke otentikasi pengguna (proses logout)
    def destroy        
        if header_authorization.present?
            token = header_authorization.split(' ').last
            render json: { message: 'Logout berhasil' }, status: 200
            process_to_denylist(token)
        else
            render json: { warning: 'Anda harus login terlebih dahulu' }, status: 422
        end
    end


    
end