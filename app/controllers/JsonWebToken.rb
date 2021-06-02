class JsonWebToken
    # Class JsonWebToken digunakan untuk membuat dan membuka token dari JWT.
    SECRET_KEY = Devise.secret_key

    # def self.encode(payload, exp=2.hours.from_now.to_i)
    def self.encode(payload, exp=1.year.from_now.to_i)
        # payload dari session_controller dan registration_controller
        # exp (expire) digunakan untuk memvalidasi token sampai waktu yang ditentukan
        # Default dari expire adalah 2 jam dari sekarang
        # Expire dapat diubah dengan membypass ketika memanggil method API::JsonWebToken.encode
        payload[:exp] = exp.to_i
        JWT.encode(payload, SECRET_KEY)
    end

    def self.decode(token)
        decoded = JWT.decode(token, SECRET_KEY, true, { verify_iat: true, algorithm: 'HS256' })[0]
        HashWithIndifferentAccess.new decoded
    end
end
