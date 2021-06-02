# Module Helpers::APIHelper digunakan untuk membuat suatu fungsi bantuan
# Fungsi tersebut bukan Main Core dari arsitektur MVC, tetapi dapat membantu proses dari Model, View atau Control
# untuk menjalankan tugasnya.
module Helpers::ApiHelper

    # Method untuk mendapatkan header Autorisasi
    def header_authorization
        request.headers['Authorization']
    end

    def password
        params[:password]
    end

    def email
        params[:email]
    end

    # Memproses token ke Denylist, sehingga token tidak dapat digunakan kembali
    def process_to_denylist(token)
        decode_token = JsonWebToken.decode(token)
        jti_payload = {
            jti: decode_token['jti'],
            expired_at: Time.at(decode_token['exp'])
        }
    
        JwtDenylist.create!(jti_payload)
    end

    # Mengembalikan nilai true jika 'jti' hasil decode dari header berada dalam database JwtDenylist
    # Atau nilai false jika tidak terdapat di database
    def token_was_denied?(decode)
        JwtDenylist.find_by_jti(decode['jti'])
    end
    
    def password_match_validation?
        # minimum 8 karakter: {terdiri dari angka, karakter unik, huruf kapital}
        password.match(/\A(?=.*\d)(?=.*[A-Z])(?=.*\W)[^ ]{8,}\z/) if password.present?
        true
    end

    def auth_response(id, email, token)

        reg_res = {}

        reg_res["data"] = { type: controller_name }

        reg_res["data"]["attributes"] = {}
        reg_res["data"]["attributes"]["id"] = id
        reg_res["data"]["attributes"]["email"] = email
        reg_res["data"]["attributes"]["token"] = token
        reg_res["status"] = 200

        return reg_res
    end

    
end