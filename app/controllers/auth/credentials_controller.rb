# frozen_string_literal: true

class Auth::CredentialsController < Devise::PasswordsController
    include Helpers::ApiHelper

    # =========================================================================== #
        # Error response dari method update di Credentials Controller yaitu:
        # 1. Jika tidak ditemukan token: Error 401
        # 2. Jika token salah (Verifikasi atau proses decode error): Error 401
        # 3. Jika token expired: Error 401
        # 4. Jika token sudah terdaftar di jwt_denylist: Error 400
        # 5. Jika parameter pada url salah: Error 400
        # 6. Jika format email tidak valid: Error 422
        # 7. Jika email sudah terdaftar di sistem: Error 422
        # 8. Jika format password tidak sesuai validasi: Error 422
    # =========================================================================== #
  
    def update
    # Fungsi update ini menerima 2 jenis parameter (terpisah)
    # Parameter email atau parameter password
    # Semua parameter menggunakan HTTP Verb PUT

        if header_authorization.present?
            auth_token = header_authorization.split(' ').last
    
            begin
                # Proses awal decode
                decode = JsonWebToken.decode(auth_token)
                user = User.find(decode['id'])
    
                # Cek jika parameter API adalah password, dan cek jika token yang digunakan adalah
                # Token yang valid. Pengecekan berdasarkan Waktu Expired atau berdasarkan Blacklist token
                if password && !token_was_denied?(decode)
    
                    if password_match_validation? # Sesuai menggunakan validasi Regex
                        # Menggunakan method dari Devise::Recoverable#reset_password
                        # Parameter berisi 2, yaitu new password dan new password confirmation
                        user.reset_password(password, password)
                        render json: { message: 'Password berhasil diubah, silahkan login kembali untuk melanjutkan' }, status: 200
                        process_to_denylist(auth_token)
                    else
                        render json: { 
                            warning: "Password tidak valid. Pastikan password terdiri dari: Minimum 6 karakter, 1 kapital, 1 angka dan 1 karakter unik. Contoh: (Ghaniy123)" }, 
                            status: 422
                    end
            
                # Pengecekan kembali jika parameter API yaitu email, dan mengecek jika token yang digunakan adalah
                # Token yang valid. Pengecekan berdasarkan Waktu Expired atau berdasarkan Blacklist token
                elsif email && !token_was_denied?(decode)

                    # Cek apakah email sudah ada di database
                    if email_exist?
                        render json: { warning: 'Email sudah terdaftar' }, status: 422 # Unprocessable Entity
                    elsif user.update(email: email)
                        render json: { message: 'Email berhasil diubah' }, status: 200
                    else
                        # Exception jika format email tidak valid dengan Regex yang ada di initializers/devise.rb
                        render json: { warning: user.errors.full_messages[0] }, status: 422
                    end

                else
                    # Response jika parameter salah atau token sudah tidak valid (bukan karena expired)
                    render json: { error: 'Parameter salah atau ada masalah dengan kredensial Anda' }, status: 400 # Bad Request
                end
            
            # Rescue akan tercapai jika token yang dibawa oleh header Authorization sudah cacat dari awal
            # Cacat dari awal jika saat proses awal decode sudah menghasilkan error.
            rescue  JWT::ExpiredSignature
                render json: { error: 'Your session has expired, please Login to continue' }, status: 401
            rescue  JWT::VerificationError,
                    JWT::DecodeError
                render json: { error: '401 Unauthorized' }, status: 401
            end
    
        else
            # Menampilkan pesan 401 jika tidak terdapat token pada header Authorization
            render json: { error: '401 Unauthorized' }, status: 401
        end
    end

    private
  
    def email_exist?
      User.find_by_email(email)
    end
  
  end