class ApplicationController < ActionController::API
    before_action :authorize_request

    include Helpers::ApiHelper

    # RAILS API does'nt include this module.
    # So We can include to use ErrorResponseAction functionality
    include ActionController::MimeResponds

    # ErrorResponseAction adalah modul untuk menampilkan 
    # tampilan custom dari error-error umum
    include ErrorResponseActions
    rescue_from ActiveRecord::RecordNotFound, :with => :resource_not_found

    # ========================================================= #
        # Panduan padanan response JSON terhadapat HTTP Status
        # 200 OK: JSON Response { message: }
        # 422 Unprocessable Entity: JSON Response { warning: }
        # 401 Unauthorized: JSON Response { error: }

        # NB: Harap digunakan pada semua Controller API
    # ========================================================= #

    private

    def authorize_request
        if header_authorization.present?
            # Fungsi split(' ').last adalah untuk memisahkan headers 'Authorization'.
            # Ketika header dibaca, kolom otorisasi akan terbaca seperti ini
            # Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MywiZW1haWwiOiJsYXJhc..........
            # Yang dibutuhkan hanyalah tokennya saja, tidak perlu deklarasi header Bearer nya
            auth_token = header_authorization.split(' ').last

            begin
                decode_token = JsonWebToken.decode(auth_token)
                @current_user_id = decode_token['id']
                
                # Raise 401 jika hasil dari token_was_denied? adalah true
                render json: { error: '401 Unauthorized' }, status: 401 if token_was_denied?(decode_token)
            rescue  JWT::ExpiredSignature 
                render json: { error: 'Your session has expired, please Login to continue' }, status: 401
            rescue  JWT::VerificationError,
                    JWT::DecodeError
                render json: { error: '401 Unauthorized' }, status: 401
            end
        end
    end

    def authenticate_user!(options = {})
        render json: { error: '401 Unauthorized' }, status: 401 unless signed_in?  
    end
    
    def current_user
        super || User.find(@current_user_id)
    end
    
    def signed_in?
        @current_user_id.present?
    end    

end
